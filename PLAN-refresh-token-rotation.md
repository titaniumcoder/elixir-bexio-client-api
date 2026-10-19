# Plan: Persist OAuth refresh token rotation from Bexio (Keycloak)

# Plan: Persist OAuth refresh token rotation from Bexio (Keycloak)

> **Correction (post-incident review):** the rotation assumption was wrong. The
> old refresh token still worked from a different IP, so Bexio does NOT currently
> rotate refresh tokens (Keycloak rotates only when the realm enables
> "Revoke Refresh Token"). The actual incident cause was the retry flood getting
> the OAuth client blacklisted per IP (403). Rotation support in this plan stays
> as **defensive handling** (Keycloak can enable rotation anytime); the anti-
> retry-storm guards (R1-R5) are the actual fix for the incident.

> Status: plan (not yet implemented). Spec originated from another agent; reviewed
> against the actual code in `lib/bexio_api_client.ex` and
> `lib/bexio_api_client/req/access_token_refresher.ex` on 2026-02-19.

## Background

Bexio's token endpoint (`https://auth.bexio.com/realms/bexio/protocol/openid-connect/token`,
a Keycloak realm) now performs **refresh token rotation**: every token response
contains a NEW `refresh_token`; the previously used one is invalidated. Reusing a
stale token gets rejected, and repeated retries get the OAuth client **blacklisted**
(`{"reason": "blacklisted", "status": "blocked"}`).

This library currently discards the rotated refresh token in two places. A host app
therefore refreshes successfully exactly once, then fails forever and risks
blacklisting through retry floods.

## Verified problem inventory

### Bug 1 — `BexioApiClient.access_token/3` (lib/bexio_api_client.ex ~line 83)

The token response contains `refresh_token` (the function's own `@doc` documents
it), but only `access_token` and `expires_in` are extracted:

```elixir
case response.body do
  %{"access_token" => access_token, "expires_in" => expires_in} ->
    {:ok, access_token, expires_in}
  _ -> {:error, {:unexpected_response, response.body}}
end
```

The rotated refresh token is dropped.

### Bug 2 — `BexioApiClient.Req.AccessTokenRefresher`

- `fetch_new_access_token_and_store/4` calls the broken `access_token/3`.
- The ETS cache is keyed by `{client_id, refresh_token}` with the ORIGINAL refresh
  token. After rotation, the next request replays the dead token forever.
- The refresher never propagates the rotated token anywhere the host can persist.

### Bug 3 (found during review, not in the original spec)

`AccessTokenRefresher.remove_expired_tokens/0` deletes via
`:ets.delete(:test, k)` — the hard-coded table name `:test` instead of
`@ets_table_name`. Expired-token cleanup never works (and crashes with
`badarg` unless a table literally named `:test` exists). Fix alongside.

### Bug 4 (found during review)

On refresh failure, `get_access_token/1` returns `req` unchanged — the request then
proceeds **without a bearer token** and fails downstream with an auth error that
looks like an API error, inviting retries that worsen the blacklisting problem.
The failure should surface as a request error instead.

## Design decision: API shape and versioning

Two options; **recommend Option A**:

- **Option A (recommended): breaking change, released as `1.0.0`** (the library graduates to stable SemVer).
  Change `access_token/3` to return `{:ok, token_map}` where `token_map` contains
  `:access_token`, `:expires_in`, and optionally `:refresh_token`, `:id_token`,
  `:scope`, `:token_type` (present in response, else `nil`). The library is
  stable enough for 1.0; SemVer applies in full from here on. Cleaner than a permanently deprecated
  duplicate function. `AccessTokenRefresher` (internal-ish plugin) is updated in
  the same release.
- Option B (fallback if the maintainer wants zero breakage): keep `access_token/3`
  returning `{:ok, access_token, expires_in}` but mark `@doc deprecated:`,
  and add `access_token_full/3` returning the map, released as an additive minor.

Do not implement both variants — pick one and be consistent throughout docs.

## Anti-retry-storm strategy (refresh failure handling)

> How production got blacklisted: every request through the client runs the refresher
> step independently; there is no failure cache, lock, or backoff. After rotation
> broke refresh, each concurrent API call re-POSTed the dead token to Keycloak —
> a retry flood at request rate, not retry rate. Additionally `access_token/3`
> builds a bare `Req.new()` that inherits Req's **default retry** (and the shared
> app `:req_options`), so even a single call can multiply its token-endpoint hits.

### R1. Never let Req retry the token endpoint blindly

In `access_token/3`, build the IDP request with `retry: false` (and keep it
isolated from host `:req_options` that carry API-level retry config). Retry
policy for the token endpoint belongs to the refresher, which knows the error
class — not to Req's generic transient logic.

### R2. Classify refresh failures (structured errors from `access_token/3`)

- `400` with `%{"error" => "invalid_grant"}` (Keycloak's response for a
  rotated/dead refresh token) and `401` → `{:error, :invalid_refresh_token}` —
  **permanent**: retrying cannot succeed and only pushes Keycloak towards
  blacklisting.
- `429` → `{:error, {:rate_limited, retry_after_ms}}` (honor `Retry-After` if
  present). The blacklist response `%{"reason" => "blacklisted", "status" => "blocked"}`
  may surface as 403/400 — map it to a distinct `{:error, :client_blacklisted}`
  class, also permanent.
- 5xx, timeouts, connection errors → `{:error, {:transient, reason}}` — the only
  retryable class.

### R2a. Diagnostics: capture the real error shape (cheap, do this first)

The incident errors were useless — `{:error, :unauthenticated}` and
`{:error, exception}` throw away exactly the information needed to classify the
failure. Before (or alongside) the classification work in R2, patch
`access_token/3` so the next incident or the unblock attempt captures the
failure definitively:

- Enrich the unexpected-response error tuple with the HTTP status:
  `{:error, {:unexpected_response, response.status, response.body}}` instead of
  `{:error, {:unexpected_response, response.body}}`.
- Replace the bare `{:error, :unauthenticated}` on 401 with the same enriched
  tuple (status + body) so an `invalid_grant` body masquerading as 401 is not
  silently collapsed.
- Log the **full `Req.Response`** (status, headers, body — `inspect(response)`)
  via `Logger.error` on every failure path. Headers matter: `Retry-After`,
  Keycloak's `WWW-Authenticate`, and any blacklist reason headers only appear
  there.
- Caveat to document: these logs may contain the response body of a token
  response on unexpected-success shapes — review log redaction policy (never log
  the request form, which contains the refresh token; response bodies of
  failures do not contain tokens).
- R2's error classes are then implemented as a mapping **on top of** this
  enriched tuple, so the raw status/body is never lost even after
classification.

### R3. Negative cache + per-error-class backoff in the refresher

Store failure state in a second ETS table (e.g. `:bexio_api_client_refresh_failures`)
keyed by the same cache key (client_id / optional cache_key):
`{error_class, failure_count, next_retry_at}`.

- **Before** fetching a token, consult the failure entry: if
  `System.system_time(:millisecond) < next_retry_at`, fail fast — halt the
  request with `{:error, {:refresh_backoff, retry_in_ms}}` instead of hitting the
  endpoint. Emit `[:bexio_api_client, :refresh, :backoff]` telemetry.
- Backoff policy per class:
  - `:invalid_refresh_token` / `:client_blacklisted`: **no automatic retry** —
    fail fast until the host supplies a new refresh token (hook/telemetry lets
    the host react; a host can clear the failure entry via a public
    `clear_refresh_failure/1`). This is the single most important rule: these are
    exactly the errors whose retries caused the blacklist.
  - `:rate_limited`: honor `Retry-After`, else exponential 1s → 2s → 4s… capped
    at 60s.
  - `:transient`: exponential with jitter (base 500ms, factor 2, ±20% jitter,
    cap 30s); after N attempts (e.g. 5) escalate to a long fail-fast window
    (e.g. 5 min) so a degraded IDP cannot be hammered either.
- Clear the failure entry on successful fetch.
- Emit `[:bexio_api_client, :refresh, :failed]` with `%{error_class: ..., failure_count: ...}`
  metadata so hosts can alert before blacklisting happens.

### R4. Single-flight refresh (thundering-herd guard)

Use an ETS mutex (`:ets.insert_new` on a lock key) so that with N concurrent
requests only ONE process refreshes; the others wait briefly (lightweight sleep
loop, bounded to a few seconds) and then read the freshly stored token from the
cache. Prevents N-in-flight refreshes racing on a cold cache or after expiry —
important for Oban-style concurrent workers.

### R5. Fail loudly and push retries to the right layer

Combined with the Bug 4 fix: a refresh failure halts the request with a clear
error. Host-side schedulers (Oban backoff, GenServer handles, user-facing error)
are then the retry layer — the library's own backoff only guards the token
endpoint itself. Document this division in README/moduledoc: do not wrap
requests in your own retry loops; transient token failures are already backed
off, permanent ones will never succeed.

### Tests for the storm guards

- invalid_grant response → exactly ONE token-endpoint request, then fail-fast
  without further endpoint hits (count stub invocations).
- backoff window: second request within the window performs zero HTTP calls and
  returns `{:error, {:refresh_backoff, _}}`.
- transient errors back off exponentially with jitter within bounds, cap respected.
- 429 honors `Retry-After`.
- success clears the failure entry.
- single-flight: N concurrent refresh attempts on cold cache → exactly one stub
  token call.
- blacklist response maps to `:client_blacklisted` and disables retries.
- `clear_refresh_failure/1` re-enables fetching.

## Implementation steps

### 1. `BexioApiClient.access_token/3` (or `access_token_full/3` under Option B)

- Require `access_token` and `expires_in` in the response body via pattern
  matching; extract `refresh_token`, `id_token`, `scope`, `token_type` with
  `Map.get(body, "refresh_token")` etc. (optional, `nil` when absent — rotation
  behaviour must not be assumed, only supported).
- Per R2a: all error paths return enriched tuples
  (`{:error, {:unexpected_response, status, body}}`) and log the full
  `Req.Response`; classification (R2) maps on top without discarding the raw
  status/body.
- Return `{:ok, %{access_token: ..., expires_in: ..., refresh_token: ..., ...}}`.
- Update `@spec` and `@doc`: document the rotation semantics, that the returned
  `refresh_token` (when non-nil) MUST be persisted by the host, and the Keycloak
  token URL. Link https://docs.bexio.com.
- Keep this function free of ETS/cache concerns — it is the raw token endpoint call.

### 2. `BexioApiClient.Req.AccessTokenRefresher`

- Consume the new map-shaped response.
- **ETS re-keying**: key the cache by `client_id` alone; value
  `{access_token, expires_at, current_refresh_token}`. On fetch success, the entry
  is overwritten under the same `client_id` key — no stale-key accumulation.
  - Migration concern: old entries keyed `{client_id, refresh_token}` become
    invisible; acceptable for a cache with short TTL — document it. Optionally
    delete legacy keys on first write.
- **Rotation propagation (two complementary mechanisms):**
  1. **Telemetry event** `[:bexio_api_client, :refresh_token_rotated]`:
     - measurements: `%{count: 1}`
     - metadata: `%{client_id: client_id, old_refresh_token_hash: ..., new_refresh_token_hash: ...}`
       — **never include secret token values in metadata**; emit only hashes (e.g.
       first 8 bytes of `:crypto.hash(:sha256, token)`) so hosts can correlate
       events without leaking secrets.
  2. **Persistence hook**: new registered option `on_refresh_token_rotated` — an
     MFA tuple `{module, function, extra_args}` invoked as
     `apply(m, f, extra_args ++ [client_id, new_refresh_token])`. The refresher
     cannot persist to the host's DB itself; this is the mechanism for the host to
     do so. Fire-and-forget with error logging (a hook crash must not fail the
     request).
  - Within the current request, also `Req.Request.merge_options(req, refresh_token: new_rt)`
    and use it for the ETS value so any retries within the same request struct use
    the live token. Note in docs: this does NOT persist across separate host
    requests — the hook/telemetry is required for that.
- **Fix error handling (Bug 4)**: on refresh failure halt the request with the
  structured error (see R2/R5) instead of proceeding unauthenticated.
- **Fix `remove_expired_tokens/0` (Bug 3)**: `:ets.delete(@ets_table_name, k)`
  and match against the new value shape.
- Update `attach/2` to register the new option.

### 3. Docs

- Update moduledoc of `BexioApiClient` and `AccessTokenRefresher`:
  - refresh token rotation behaviour + blacklisting warning,
  - new return shape (Option A) or `access_token_full/3` (Option B),
  - the `on_refresh_token_rotated` hook contract with an example
    (GenServer/persistent store snippet),
  - telemetry event name and metadata shape (add to the existing telemetry
    section introduced in 0.9.0),
  - link https://docs.bexio.com.
- Update `README.md` token-refresh section accordingly.

### 4. Tests (no network — stub via `Req.Test` / mocked IDP URL)

- `access_token/3` (or `access_token_full/3`) parses a response containing
  `refresh_token` and returns it in the map; also test a response WITHOUT
  `refresh_token` (fields default to `nil`), and error paths:
  error tuples carry `{status, body}` (R2a), including a 401 with an
  `invalid_grant`-style body, and the full response is logged.
- `AccessTokenRefresher`:
  - first request fetches and stores (keyed by `client_id`),
  - response with new `refresh_token` → ETS entry overwritten under the same
    `client_id` key with the new refresh token; a second simulated request with
    the OLD token reuses the cached entry / uses the new token (assert no replay
    of the dead token against the stubbed token endpoint),
  - `on_refresh_token_rotated` hook invoked with new token (use a test process
    mailbox to assert),
  - telemetry event emitted (attach a `:telemetry.attach` handler in test),
  - hook raising does not break the request,
  - `remove_expired_tokens/0` actually deletes expired entries (regression for
    the `:test` table bug),
  - refresh failure produces a request error, not an unauthenticated request.
- Backward-compat path: only needed under Option B; under Option A instead assert
  the new return shape everywhere.

### 5. Quality gates and release

- `mix format`, `mix credo --no-color`, `mix test`, `mix dialyzer` — all green.
  (See "Tests for the storm guards" above for the retry-storm test matrix.)
- Release as `1.0.0` (breaking under Option A). Fill the `## [Unreleased]` CHANGELOG
  section per Keep a Changelog, prominently describing:
  - the rotation behaviour and that hosts MUST persist rotated tokens,
  - the return-shape change (Option A) or new function (Option B),
  - the new hook option and telemetry event,
  - the `remove_expired_tokens/0` and error-handling fixes.
- Release via the `release` skill (version bump + CHANGELOG + commit + tag; CI
  publishes to Hex).

## Risks / open questions

- **Version choice (A vs B)** — needs maintainer sign-off before implementation.
- Hosts that ignore the hook will still break after one refresh cycle — this is
  unavoidable without a storage layer in the library; mitigation is loud docs +
  CHANGELOG warnings (and the telemetry event as a monitoring signal).
- Keying ETS by `client_id` alone means one token per client per node; multi-user
  hosts that share one `client_id` across users must use distinct `client_id`s or
  include a per-user key — confirm with the maintainer whether an additional
  `cache_key` option is warranted (recommend: add optional `cache_key` option
  defaulting to `client_id`).
- ~~Consider (optional follow-up): retry/backoff guard on rejected refresh tokens~~
  — promoted to a core part of this fix, see "Anti-retry-storm strategy" (R1–R5):
  production was blacklisted precisely because this was missing.