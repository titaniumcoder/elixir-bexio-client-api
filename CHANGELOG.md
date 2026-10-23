# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [2.0.0] - 2026-10-23

### Changed

- **BREAKING — more "Elixir style" API (major release)**: this release makes the client
  idiomatic Elixir instead of mirroring bexio's raw JSON naming. The JSON keys sent to and
  received from the API are unchanged — only the parsed struct representation changes.
  Changes to **existing** struct fields and types (these are the breaking parts):

  | bexio JSON value | before | now |
  |---|---|---|
  | `Country.iso_3166_alpha2` | `country.iso_3166_alpha2` (string) | `country.iso3166_alpha2` (the docs' spelling wins even though it looks like a typo on their side; parser accepts both response spellings) |
  | `File.extension` | `:png` (atom via `String.to_atom/1`) | `"png"` (string — the extension set is open, not a documented enum) |
  | `DocumentSetting.kb_item_class` | `:KbOffer` (PascalCase atom) | `:kb_offer` / `:kb_order` / `:kb_invoice` / `:kb_delivery`; unknown class names stay strings |
  | `Permission.permissions` keys and scopes | atoms for every key | atoms for the documented components/scopes; unknown components and scopes stay strings |


### Added
- `BexioApiClient.Timesheets` — the whole `/2.0/timesheet` resource (list, search,
  fetch, create, edit, delete) plus the timesheet status list (`/2.0/timesheet_status`),
  with the `Timesheet`, `TimesheetStatus` and `Tracking` structs.
- `BexioApiClient.Projects` — the whole `/2.0/pr_project` resource (list, search,
  fetch, create, edit, delete, archive, reactivate) plus project statuses
  (`/2.0/pr_project_state`) and project types (`/2.0/pr_project_type`), with the
  `Project`, `ProjectState` and `ProjectType` structs.
- `BexioApiClient.Projects` — milestones and work packages of projects
  (`/3.0/projects/{project_id}/milestones` and `/3.0/projects/{project_id}/packages`):
  list, create, fetch, edit and delete both resources, with the new
  `Milestone` and `WorkPackage` structs.
- Contact-area write operations: `create_contact/2`, `edit_contact/2`,
  `delete_contact/2`, `bulk_create_contacts/2` (`POST /2.0/contact/_bulk_create`)
  and `restore_contact/2` (`PATCH /2.0/contact/{id}/restore`), plus `new/1`
  builders for `Contact`, `ContactRelation` and `AdditionalAddress`.
- Contact relations: `create_contact_relation/2`, `edit_contact_relation/2`,
  `delete_contact_relation/2`.
- Contact groups: `create_contact_group/2`, `edit_contact_group/3`,
  `delete_contact_group/2`.
- Additional addresses: `create_additional_address/3`,
  `edit_additional_address/3`, `delete_additional_address/3`.
- Salutations: `create_salutation/2`, `edit_salutation/3`, `delete_salutation/2`.
- Titles: `create_title/2`, `edit_title/3`, `delete_title/2`.
- `SalesOrderManagement` quote actions: `copy_quote/4`, `send_quote/3`,
  `create_order_from_quote/2`, `create_invoice_from_quote/2`
  (POST `/2.0/kb_offer/{id}/copy|send|order|invoice`).
- `SalesOrderManagement` order actions: `create_delivery_from_order/2`,
  `create_invoice_from_order/2` (POST `/2.0/kb_order/{id}/delivery|invoice`)
  and order repetitions `fetch_order_repetition/2`, `edit_order_repetition/3`,
  `delete_order_repetition/2` (GET/POST/DELETE `/2.0/kb_order/{id}/repetition`)
  with the new `OrderRepetition` struct.
- `SalesOrderManagement` invoice actions: `copy_invoice/4`, `cancel_invoice/2`,
  `mark_invoice_as_sent/2`, `send_invoice/3`
  (POST `/2.0/kb_invoice/{id}/copy|cancel|mark_as_sent|send`).
- `SalesOrderManagement` invoice payments: `fetch_invoice_payments/3`,
  `create_invoice_payment/3`, `fetch_invoice_payment/3`, `delete_invoice_payment/3`
  (GET/POST `/2.0/kb_invoice/{id}/payment`, GET/DELETE
  `/2.0/kb_invoice/{id}/payment/{payment_id}`) with the new `Payment` struct.
- `SalesOrderManagement` invoice reminders: `fetch_invoice_reminders/2`,
  `create_invoice_reminder/2`, `search_invoice_reminders/3`,
  `fetch_invoice_reminder/3`, `delete_invoice_reminder/3`,
  `mark_invoice_reminder_as_sent/3`, `mark_invoice_reminder_as_unsent/3`,
  `send_invoice_reminder/6`, `invoice_reminder_pdf/3`
  (GET/POST/DELETE under `/2.0/kb_invoice/{id}/kb_reminder`) with the new
  `Reminder` struct.
- Purchase area: bills (bexio API v4: create/show/update/delete, bookings status,
  actions and document number validation), expenses (v4: CRUD, bookings status,
  actions and document number validation), purchase orders (v3: CRUD) and outgoing
  payments (v4: list/create/show/update/delete) with the new `Bill`, `BillLineItem`,
  `BillDiscount`, `BillPayment`, `Expense`, `PurchaseOrder`, `OutgoingPayment`,
  `Address` and `DocumentNumber` structs.
- `BexioApiClient.Banking` — bank accounts (bexio API v3: list/show
  `/3.0/banking/accounts`) and payments (bexio API v4: list/create/show/update/
  delete/cancel on `/4.0/banking/payments`, covering the IBAN and QR payment
  type variants), with the `BankAccount` and `Payment` structs.
- Accounting: missing accounting operations — calendar years (`create_calendar_year/3`,
  `search_calendar_years/3`, `fetch_calendar_year/2`), business years (`fetch_business_years/2`,
  `fetch_business_year/2`), currencies (`create_currency/2`, `fetch_currency/2`, `edit_currency/2`,
  `delete_currency/2`, `fetch_currency_codes/1`), manual entries v3 (`fetch_manual_entries/2`,
  `create_manual_entry/2`, `edit_manual_entry/2`, `delete_manual_entry/2`,
  `fetch_next_manual_entry_reference_nr/1`), manual entry file attachments (line and compound
  entry variants), journal (`fetch_journal/2`), taxes (`fetch_tax/2`, `delete_tax/2`) and
  vat periods (`fetch_vat_periods/2`, `fetch_vat_period/2`) with the new `BusinessYear`,
  `VatPeriod`, `JournalEntry`, `ManualEntry`, `ManualEntryLine` and `ManualEntryFile`
  structs and a `Currency.new/1` builder.
- `BexioApiClient.BusinessActivities` — business activities, client services
  and communication types: `GET`/`POST` `/2.0/client_service`,
  `POST` `/2.0/client_service/search`, `GET`/`POST` `/2.0/business_activity`,
  `POST` `/2.0/business_activity/search`, `GET` `/2.0/communication_kind` and
  `POST` `/2.0/communication_kind/search` with the new `BusinessActivity`
  and `CommunicationType` structs.
- `Others`: `create_country/2`, `edit_country/2` and `delete_country/2`
  (`POST /2.0/country`, `POST /2.0/country/{id}`, `DELETE /2.0/country/{id}`)
  plus a `Country.new/1` builder.
- `Others.fetch_me/1` — `GET /3.0/users/me`, the authenticated user.
- `Others.fetch_document_templates/1` — `GET /3.0/document_templates`, with the
  new `BexioApiClient.Others.DocumentTemplate` struct.
- `BexioApiClient.Payroll` — employees, employee absences and the paystub PDF
  download (`/4.0/payroll/...`), with the `Employee`, `Absence` and `Address`
  structs.
- `BexioApiClient.Files` — missing file operations: `create_file/2` (multipart
  upload), `update_file/2`, `delete_file/2`, `fetch_file_usage/2` plus the
  `BexioApiClient.Files.FileUsage` struct.

- `docs/bexio-openapi.json` / `docs/bexio-openapi.yaml` — unofficial OpenAPI 3.0
  reconstruction of the bexio API, regenerated from the live docs; not the
  source of truth for this library.
- `Contact`: new fields `street_name`, `house_number`, `address_addition`,
  `lead?` (bexio's `is_lead`) and `profile_image` (show response only).
- `AdditionalAddress`: new fields `name_addition`, `street_name`, `house_number`,
  `address_addition`.
- `File`: new field `source_id` (deprecated by bexio in favor of `source_type`).
- `Item`: new fields `account_id`, `expense_account_id` and `html_text`
  (deprecated by bexio).
- `Tax`: new fields `start_month`, `end_month`.
- `CalendarYear`: new field `annual_reporting?` (bexio's `is_annual_reporting`).
- `Currency`: new embedded default exchange rate fields `exchange_rate`,
  `exchange_rate_date`, `exchange_rate_id`, `exchange_rate_to_ratio`, `ratio`,
  `source`, `source_reason` (`nil` for the base currency).
- `Quote`, `Order`, `Invoice`, `Delivery`: new field `logopaper_id`
  (deprecated by bexio in favor of `template_slug`).
- `Delivery`: new fields `viewed_by_client_at` and `template_slug`.
- `docs/UNTRUTHS.md` — documented divergences between the official docs and
  this library / the real API.
- `File.extension` is kept as a string: the set of extensions is open, not a documented
  enum, and must not be converted to atoms dynamically.
- `DocumentSetting.kb_item_class` is converted to idiomatic atoms
  (`:kb_offer`/`:kb_order`/`:kb_invoice`/`:kb_delivery`); unknown class names are kept
  as strings.
- `Permission.permissions` keys are atoms for the documented components; unknown
  components are kept as string keys. Values of unknown scopes are kept as strings.
- `Contact.nr` no longer crashes when bexio returns `null` (documented as
  "string or null"); `nil` is mapped to `nil`.
- `CalendarYear.vat_accounting_method`/`vat_accounting_type` no longer crash
  when they are `null` (calendar year not subjected to VAT).
- `File.source_type` no longer crashes when it is `null`.


- `docs/bexio-openapi.json` / `docs/bexio-openapi.yaml` — unofficial OpenAPI 3.0
  reconstruction of the bexio API, regenerated from the live docs; not the
  source of truth for this library.
- `Contact`: new fields `street_name`, `house_number`, `address_addition`,
  `lead?` (bexio's `is_lead`) and `profile_image` (show response only).
- `AdditionalAddress`: new fields `name_addition`, `street_name`, `house_number`,
  `address_addition`.
- `File`: new field `source_id` (deprecated by bexio in favor of `source_type`).
- `Item`: new fields `account_id`, `expense_account_id` and `html_text`
  (deprecated by bexio).
- `Tax`: new fields `start_month`, `end_month`.
- `CalendarYear`: new field `annual_reporting?` (bexio's `is_annual_reporting`).
- `Currency`: new embedded default exchange rate fields `exchange_rate`,
  `exchange_rate_date`, `exchange_rate_id`, `exchange_rate_to_ratio`, `ratio`,
  `source`, `source_reason` (`nil` for the base currency).
- `Quote`, `Order`, `Invoice`, `Delivery`: new field `logopaper_id`
  (deprecated by bexio in favor of `template_slug`).
- `Delivery`: new fields `viewed_by_client_at` and `template_slug`.
- `docs/UNTRUTHS.md` — documented divergences between the official docs and
  this library / the real API.

### Changed

- `File.extension` is kept as a string: the set of extensions is open, not a documented
  enum, and must not be converted to atoms dynamically.
- `DocumentSetting.kb_item_class` is converted to idiomatic atoms
  (`:kb_offer`/`:kb_order`/`:kb_invoice`/`:kb_delivery`); unknown class names are kept
  as strings.
- `Permission.permissions` keys are atoms for the documented components; unknown
  components are kept as string keys. Values of unknown scopes are kept as strings.

### Fixed

- `Contact.nr` no longer crashes when bexio returns `null` (documented as
  "string or null"); `nil` is mapped to `nil`.
- `CalendarYear.vat_accounting_method`/`vat_accounting_type` no longer crash
  when they are `null` (calendar year not subjected to VAT).
- `File.source_type` no longer crashes when it is `null`.

## [1.0.0] - 2026-10-19

First stable release. The library has been actively maintained and used in
production long enough as pre-1.0; from here on the API is considered stable
and [Semantic Versioning](https://semver.org/spec/v2.0.0.html) applies in full.

### Added

- Refresh failure classification with automatic backoff: `400`/`401` `invalid_grant`
  and `403` (blacklisted) responses are permanent and fail fast without further
  token endpoint calls; all other failures (including `429`) back off
  exponentially with jitter for ~4.5 minutes of probing before a 10-minute
  cooldown. This prevents the retry flood (per OAuth client and
  per IP) that got production clients blacklisted by Bexio.
- `[:bexio_api_client, :refresh, :failed]` and `[:bexio_api_client, :refresh, :backoff]`
  telemetry events.
- `BexioApiClient.RefreshError` — refresh failures halt the request instead of
  sending it unauthenticated.
- `BexioApiClient.Req.AccessTokenRefresher.clear_refresh_failure/1` to re-enable
  refresh after a permanent failure (e.g. after the host obtained a new refresh
  token).
- `:on_refresh_gave_up` option (`{module, function, args}` MFA, invoked as
  `apply(m, f, args ++ [client_id, error_class])`): invoked once when the
  refresher gives up on a refresh token (first permanent failure, or entering
  the transient-failure cooldown), so host applications can re-authenticate,
  disable sync jobs or alert.
- `BexioApiClient.Req.RetryPolicy` behaviour documenting the API request retry
  contract, implemented by `BexioApiClient.Req.RewriteDelay`. Host applications
  can provide their own policy via Req's `:retry` option.

### Changed

- **BREAKING**: `BexioApiClient.access_token/3` now returns the full token map
  `{:ok, %{access_token: ..., expires_in: ..., refresh_token: ..., id_token: ..., scope: ..., token_type: ...}}`
  instead of `{:ok, access_token, expires_in}`.
- `access_token/3` returns the full token map, including the `refresh_token` the
  response contains. Bexio does not currently rotate refresh tokens and the
  refresher does not manage rotation; should Bexio ever enable it (a Keycloak
  realm option), host applications can persist the new token from the map and
  pass it to `new/3` themselves.
- `access_token/3` error returns are enriched with the HTTP status:
  `{:error, {:unexpected_response, status, body}}`, and the full `Req.Response`
  is logged on failure for diagnostics.
- The token endpoint is never retried by Req itself; retry policy belongs to the
  refresher. Arbitrary exceptions are no longer retried.

### Fixed

- The `refresh_token` in the token response was silently dropped by
  `access_token/3`, so it was never visible to host applications.
- `remove_expired_tokens/0` deleted from the wrong ETS table and never removed
  expired entries.
- Requests proceeded unauthenticated after a failed refresh, inviting the retry
  flood that got OAuth clients blacklisted by Bexio.

## [0.9.0] - 2026-02-07

### Added

- Comprehensive telemetry support for monitoring API usage:
  - `[:bexio_api_client, :request, :success]` - track successful requests (status 200-399)
  - `[:bexio_api_client, :request, :error]` - track error responses (status 400+)
  - `[:bexio_api_client, :rate_limit, :hit]` - track rate limit hits with wait times
  - `[:bexio_api_client, :request, :retry]` - track retry attempts for server errors
- `:telemetry` dependency (~> 1.0)

## [0.8.0] - 2025-10-28

### Changed

- Project transferred to a private GitHub repository

## [0.7.1] - 2025-02-14

### Fixed

- `article_type` in an article can also be `nil`

## [0.7.0] - 2025-01-17

### Added

- New OAuth2 access token endpoint

## [0.6.4] - 2025-01-10

### Fixed

- Treat `account_no` as string, as it seems to be allowed (although not according
  to the API documentation)

## [0.6.3] - 2025-01-10

### Fixed

- All empty bodies sent as JSON removed, fixing error 415

## [0.6.2] - 2024-09-16

### Fixed

- Placeholder version due to an issue with the build

## [0.6.1] - 2024-09-14

### Changed

- Reduced retries from 100 to 3, so rate limits can be handled but general network
  problems are not retried

## [0.6.0] - 2024-09-04

### Changed

- Dependency version updates

## [0.5.3] - 2024-07-08

### Added

- Optional configuration of the IDP URL to enable mocking the Bexio API completely
  with a customized mock

## [0.5.2] - 2024-06-12

### Added

- Test for the access token refresher logic

## [0.5.1] - 2024-06-12

### Fixed

- Forgotten access keys are now cached using temporary ETS storage

## [0.5.0] - 2024-06-04

### Added

- Payment types

### Changed

- `SearchCriteria` changed to the `~f` sigil with separators for reduced name
  lengths (old functionality is still available)

## [0.4.3] - 2024-06-03

### Added

- Logic for notes needed for the search

## [0.4.2] - 2024-06-03

### Added

- GitHub Action to automatically publish a package version

## [0.4.1] - 2024-06-03

### Added

- Logic for notes needed for the search

## [0.4.0] - 2024-05-28

### Added

- `req` as optional dependency
- `req` setup for automatic access token renewal and retry delay using Bexio
  headers

### Changed

- Removed dependency on `tesla`

[Unreleased]: https://github.com/titaniumcoder/elixir-bexio-client-api/compare/2.0.0...HEAD
[2.0.0]: https://github.com/titaniumcoder/elixir-bexio-client-api/compare/1.0.0...2.0.0
[1.0.0]: https://github.com/titaniumcoder/elixir-bexio-client-api/compare/0.9.0...1.0.0
[0.9.0]: https://github.com/titaniumcoder/elixir-bexio-client-api/compare/0.8.0...0.9.0
[0.8.0]: https://github.com/titaniumcoder/elixir-bexio-client-api/compare/0.7.1...0.8.0
[0.7.1]: https://github.com/titaniumcoder/elixir-bexio-client-api/compare/0.7.0...0.7.1
[0.7.0]: https://github.com/titaniumcoder/elixir-bexio-client-api/compare/0.6.4...0.7.0
[0.6.4]: https://github.com/titaniumcoder/elixir-bexio-client-api/compare/0.6.3...0.6.4
[0.6.3]: https://github.com/titaniumcoder/elixir-bexio-client-api/compare/0.6.2...0.6.3
[0.6.2]: https://github.com/titaniumcoder/elixir-bexio-client-api/compare/0.6.1...0.6.2
[0.6.1]: https://github.com/titaniumcoder/elixir-bexio-client-api/compare/0.6.0...0.6.1
[0.6.0]: https://github.com/titaniumcoder/elixir-bexio-client-api/compare/0.5.3...0.6.0
[0.5.3]: https://github.com/titaniumcoder/elixir-bexio-client-api/compare/0.5.2...0.5.3
[0.5.2]: https://github.com/titaniumcoder/elixir-bexio-client-api/compare/0.5.1...0.5.2
[0.5.1]: https://github.com/titaniumcoder/elixir-bexio-client-api/compare/0.5.0...0.5.1
[0.5.0]: https://github.com/titaniumcoder/elixir-bexio-client-api/compare/0.4.3...0.5.0
[0.4.3]: https://github.com/titaniumcoder/elixir-bexio-client-api/compare/0.4.2...0.4.3
[0.4.2]: https://github.com/titaniumcoder/elixir-bexio-client-api/compare/0.4.1...0.4.2
[0.4.1]: https://github.com/titaniumcoder/elixir-bexio-client-api/compare/0.4.0...0.4.1
[0.4.0]: https://github.com/titaniumcoder/elixir-bexio-client-api/compare/0.3.0...0.4.0