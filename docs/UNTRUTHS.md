# Untruths — where the bexio docs and the real API (or this library) diverge

This document records places where the official documentation at
<https://docs.bexio.com> and either the real API behaviour or this library's
implementation do not match. Entries are decided case by case: where the docs
are wrong we do **not** bend the library to match them; where the library
intentionally deviates for design reasons, it is recorded here too.

Maintained as part of the `fix/api-docs-alignment` audit (PR: docs snapshot of
2026-10-23, reconstructed in `docs/bexio-openapi.json`).

## 1. Document responses include `positions` — this library does not embed them

**Docs say:** the response examples/schemas of `GET /2.0/kb_offer/{id}`,
`GET /2.0/kb_order/{id}`, `GET /2.0/kb_invoice/{id}` and `GET /2.0/kb_delivery/{id}`
include a `positions` array (and the create/edit request bodies accept it).

**The library instead:** `BexioApiClient.SalesOrderManagement.Quote/Order/Invoice/Delivery`
structs have a `:positions` field that stays `nil` when fetching the document
itself. Positions are read and written through the dedicated position endpoints
(`kb_position_custom`, `kb_position_article`, `kb_position_text`, …) which this
library implements per position type.

**Rationale:** embedding full position parsing into every document response
duplicates the position endpoints' parsing and would make the document structs
heavily nested. Revisit if there is demand for one-shot document+positions
fetching.

## 2. Country field name `iso3166_alpha2` vs. previously assumed `iso_3166_alpha2`

**Docs say:** the country object field is `iso3166_alpha2`.

**The library did:** parse `iso_3166_alpha2` (extra underscore) — which silently
yielded `nil` for that field if the real API follows the documented spelling.

**What we do now:** the struct field is named `iso3166_alpha2` (documented
spelling wins, even if it looks like a typo), and the parser accepts **both**
spellings for robustness.

## 3. Deprecated fields the docs still return (kept, flagged as deprecated)

The docs' changelog marks several fields as deprecated while still returning
them ("still present in responses for backward compatibility"). This library
keeps parsing them so existing code keeps working, and flags them:

| Field | Where | Deprecated in favour of |
|---|---|---|
| `logopaper_id` | quotes, orders, invoices, deliveries | `template_slug` |
| `html_text` | articles | `intern_description` / plain text |
| `source_id` | files | `source_type` |
| `address` (free-text) | contacts, additional addresses | structured `street_name` / `house_number` / `address_addition` |

## 4. Contact `nr` is "string or null"

The docs describe `nr` as `string or null` ("If set to null, the number will be
assigned automatically") and the list example shows `"nr": null`. The library
previously called `String.to_integer/1` unconditionally, which crashed on the
documented `null`. It now maps `nil` to `nil` (and still converts numeric
strings to integers).
