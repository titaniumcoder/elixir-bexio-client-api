# Elixir Bexio Client API

An Elixir API client library for the [Bexio business management platform API](https://docs.bexio.com), published as the `bexio_api_client` Hex package. This is **not** a Phoenix application — it is a pure library built on top of `Req`.

## Project Structure

### Core (`lib/`)

- **bexio_api_client.ex** — Main API client module. All Bexio API endpoints plus OAuth2 token handling (`access_token/3`, token refresh).
- **bexio_api_client/req/access_token_refresher.ex** — Req request step plugin that transparently fetches and caches access tokens in ETS (keyed by `{client_id, refresh_token}`) and attaches them as bearer auth.
- **bexio_api_client/req/rewrite_delay.ex** — Req plugin handling rate limit delays/retries.
- **bexio_api_client/accounts.ex, articles.ex, ...** — One module per Bexio API resource (contacts, invoices, orders, quotes, etc.), each wrapping the plain REST endpoints.

### Tests (`test/`)

- Mirrors `lib/` structure. Tests stub HTTP responses via `Req.Test` / `plug` — **no real network calls in tests**.

## Project guidelines

- Use `mix format`, `mix credo --no-color`, `mix dialyzer`, and `mix test` to verify changes. All four must pass before committing (the Hex publish CI runs test, dialyzer, and credo).
- Use the already included and available `:req` (`Req`) library for HTTP requests, **avoid** `:httpoison`, `:tesla`, and `:httpc`.
- Keep typespecs (`@spec`) complete on all public functions — the project has strict dialyzer flags (`-Wunmatched_returns`, `:error_handling`, `:underspecs`).
- Keep `@doc` documentation current; this library's docs are published to HexDocs via `ex_doc`.
- Do not add dependencies unless truly necessary; `:telemetry` (~> 1.0) is already available for events.
- Tests must never make real network calls — stub `Req` responses (e.g. `Req.Test` or by mocking the IDP URL config).

## OAuth / token handling notes

- Bexio auth lives at `https://auth.bexio.com/realms/bexio/protocol/openid-connect/token` (a Keycloak realm); the IDP URL can be overridden in config to mock it.
- Bexio does not currently rotate refresh tokens (the same refresh token keeps working); the refresher does not manage rotation. Token responses expose the `refresh_token` via `access_token/3`; should Bexio ever enable rotation (a Keycloak realm option), host applications persist the new token themselves. Never log or leak token values.
- The refresher's ETS tables (`:bexio_api_client_access_tokens`, `:bexio_api_client_refresh_failures`, `:bexio_api_client_refresh_locks`) are owned by the creating process and die with it. Document that hosts should create them once from a long-lived process (`create_ets_table/0` in the application `start/2`); lazy creation from request processes is safe but loses the cache whenever the owner exits. Table creation must stay race-safe (`ArgumentError` from a concurrent `:ets.new` is ignored).
- Bexio blacklists misbehaving OAuth clients per IP (`403` `{"reason": "blacklisted", "status": "blocked"}`), typically after retry floods on failing refreshes. Never retry permanent refresh failures; backoff lives in `AccessTokenRefresher`. The optional `:on_refresh_gave_up` MFA notifies the host once at the give-up transition (permanent failure or transient cooldown); hosts re-enable with `clear_refresh_failure/1`.
- Access tokens are cached in the `:bexio_api_client_access_tokens` ETS table with an expiry reserve of 60s.

## Commit conventions

- Every commit message follows [Conventional Commits](https://www.conventionalcommits.org/):
  `type(optional-scope): description` in imperative mood, e.g. `fix: handle nil article_type`.
- Types in use: `feat`, `fix`, `docs`, `test`, `refactor`, `perf`, `chore`, `ci`.
- Breaking changes use `!` before the colon (`feat!: ...`) plus a `BREAKING CHANGE: <description>`
  footer explaining the breakage and the migration path.
- The description of a `fix` commit should describe the observable behaviour, not the code change.

## Changelog conventions

- `CHANGELOG.md` follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/):
  - a `## [Unreleased]` section sits at the top; changes are accumulated there while developing,
  - on release, `Unreleased` becomes `## [X.Y.Z] - YYYY-MM-DD` (ISO date),
  - entries are grouped under `### Added`, `### Changed`, `### Fixed`, `### Removed`,
    `### Deprecated`, `### Security`,
  - breaking changes are listed first under `### Changed` with a bold **BREAKING** marker
    and a migration note,
  - each version has a compare-link in the footer at the bottom of the file.

## Release / versioning

- This is a Hex package (version in `mix.exs`), published automatically by GitHub Actions
  (`.github/workflows/publish-hex.yml`) **on git tag push**. The workflow runs `mix test`,
  `mix dialyzer`, `mix credo`, then `mix hex.publish --yes`.
- Release procedure: move `CHANGELOG.md`'s `Unreleased` entries into a new `[X.Y.Z] - YYYY-MM-DD`
  section, bump `version` in `mix.exs`, commit as `chore: release v1.0.0` (or
  `chore(release): ...`), `git tag vX.Y.Z`, push commit + tag.
- Version policy: the library is stable at 1.0+. Breaking changes require a major version,
  new features a minor, bugfixes a patch (SemVer). Breaking changes must be marked with `!`
  in the commit, a `BREAKING CHANGE:` footer, and a bold **BREAKING** entry in the CHANGELOG.
- Never publish manually with `mix hex.publish` locally unless the CI route is unavailable.

<!-- usage-rules-start -->

## Elixir guidelines

- Elixir lists **do not support index based access via the access syntax**

  **Never do this (invalid)**:

      i = 0
      mylist = ["blue", "green"]
      mylist[i]

  Instead, **always** use `Enum.at`, pattern matching, or `List` for index based list access, ie:

      i = 0
      mylist = ["blue", "green"]
      Enum.at(mylist, i)

- Elixir variables are immutable, but can be rebinding, so for block expressions like `if`, `case`, `cond`, etc
  you *must* bind the result of the expression to a variable if you want to use it and you CANNOT rebind the result inside the expression, ie:

      # INVALID: we are rebinding inside the `if` and the result never gets assigned
      if connected?(socket) do
        socket = assign(socket, :val, val)
      end

      # VALID: we rebind the result of the `if` to a new variable
      socket =
        if connected?(socket) do
          assign(socket, :val, val)
        end

- **Never** nest multiple modules in the same file as it can cause cyclic dependencies and compilation errors
- **Never** use map access syntax (`changeset[:field]`) on structs as they do not implement the Access behaviour by default. For regular structs, you **must** access the fields directly, such as `my_struct.field` or use higher level APIs that are available on the struct if they exist, `Ecto.Changeset.get_field/2` for changesets
- Elixir's standard library has everything necessary for date and time manipulation. Familiarize yourself with the common `Time`, `Date`, `DateTime`, and `Calendar` interfaces by accessing their documentation as necessary. **Never** install additional dependencies unless asked or for date/time parsing (which you can use the `date_time_parser` package)
- Don't use `String.to_atom/1` on user input (memory leak risk)
- Predicate function names should not start with `is_` and should end in a question mark. Names like `is_thing` should be reserved for guards
- Elixir's builtin OTP primitives like `DynamicSupervisor` and `Registry`, require names in the child spec, such as `{DynamicSupervisor, name: MyApp.MyDynamicSup}`, then you can use `DynamicSupervisor.start_child(MyApp.MyDynamicSup, child_spec)`
- Use `Task.async_stream(collection, callback, options)` for concurrent enumeration with back-pressure. The majority of times you will want to pass `timeout: :infinity` as option

## Mix guidelines

- Read the docs and options before using tasks (by using `mix help task_name`)
- To debug test failures, run tests in a specific file with `mix test test/my_test.exs` or run all previously failed tests with `mix test --failed`
- `mix deps.clean --all` is **almost never needed**. **Avoid** using it unless you have good reason

<!-- usage-rules-end -->