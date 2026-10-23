# Calendar Years

Part of **Accounting**. Extracted from docs.bexio.com (snapshot Mon, 28 Sep 2026 12:05:15 GMT). 4 operations.

| Method | Path | Title |
|---|---|---|
| `GET` | `/3.0/accounting/calendar_years` | Fetch a list of calendar years |
| `POST` | `/3.0/accounting/calendar_years` | Create calendar year. |
| `POST` | `/3.0/accounting/calendar_years/search` | Search calendar years |
| `GET` | `/3.0/accounting/calendar_years/{calendar_year_id}` | Fetch a calendar year |

## `GET` `/3.0/accounting/calendar_years` — Fetch a list of calendar years

operationId: `ListCalendarYears`

This action fetches a list of all calendar years

### query Parameters

| Parameter | Type | Description |
|---|---|---|
| limit | integer <int32> Default: 500 | Limit the number of results (max is 2000) |
| offset | integer <int32> Default: 0 | Skip over a number of elements by specifying an offset value for the query |

### Responses

200

**200** — OK

**Response samples** (200):

```json
[
  {
    "id": 1,
    "start": "2018-01-01",
    "end": "2018-12-31",
    "is_vat_subject": true,
    "is_annual_reporting": false,
    "created_at": "2017-04-28T19:58:58+00:00",
    "updated_at": "2018-04-30T19:58:58+00:00",
    "vat_accounting_method": "effective",
    "vat_accounting_type": "agreed"
  }
]
```

---

## `POST` `/3.0/accounting/calendar_years` — Create calendar year.

operationId: `CreateCalendarYear`

This action creates a calendar year. If only year parameter is passed to request the next year is created with the same settings as the year before other way all parameters must be pass to request.

### Request Body schema: application/json *(required)*

| Parameter | Type | Description |
|---|---|---|
| year | string | The year for which we want to create an entry. It is possible to create years 10 years ahead and higher than 2016 year. If it is a future year, we generate all in between with the settings the user has chosen. |
| is_vat_subject | boolean | Determines if the calendar year is vat subjected or not. |
| is_annual_reporting | boolean | Determines if the calendar year has annual reporting enabled. |
| vat_accounting_method | string Enum: effective net_tax | Vat accounting method. |
| vat_accounting_type | string Enum: agreed collected | Vat accounting type. |
| default_tax_income_id | integer | Determine default tax ID for income. References a tax object |
| default_tax_expense_id | integer | Determine default tax ID for expense. Tax ID is not required if the client has the plan bexio mini. In this case, the year is created with the tax ID from the previous year. References a tax object. |

### Responses

201, 422

**201** — OK

**Response samples** (201):

```json
[
  {
    "id": 1,
    "start": "2018-01-01",
    "end": "2018-12-31",
    "is_vat_subject": true,
    "is_annual_reporting": false,
    "created_at": "2017-04-28T19:58:58+00:00",
    "updated_at": "2018-04-30T19:58:58+00:00",
    "vat_accounting_method": "effective",
    "vat_accounting_type": "agreed"
  }
]
```

**422** — Validation error

**Request sample**:

```json
{
  "year": "2018",
  "is_vat_subject": true,
  "is_annual_reporting": false,
  "vat_accounting_method": "effective",
  "vat_accounting_type": "agreed",
  "default_tax_income_id": 1,
  "default_tax_expense_id": 2
}
```

---

## `POST` `/3.0/accounting/calendar_years/search` — Search calendar years

operationId: `SearchCalendarYears`

This action fetches a list of all calendar years which matches the search criteria. If you want to search for end date use "like" instead of "=" cause if you search for equality, you will have to provide the date in the following format: "2018-12-31 23:59:59"

### query Parameters

| Parameter | Type | Description |
|---|---|---|
| limit | integer <int32> Default: 500 | Limit the number of results (max is 2000) |
| offset | integer <int32> Default: 0 | Skip over a number of elements by specifying an offset value for the query |

### Request Body schema: application/json *(required)*

| Parameter | Type | Description |
|---|---|---|
| field *(required)* | string | Field which should be search over |
| value *(required)* | string | Value to search for |
| criteria | string Default: like Enum: = == equal != not_equal > greater_than >= greater_equal < less_than <= less_equal like not_like is_null not_null in not_in |  |

### Responses

200, 422

**200** — OK

**Response samples** (200):

```json
[
  {
    "id": 1,
    "start": "2018-01-01",
    "end": "2018-12-31",
    "is_vat_subject": true,
    "is_annual_reporting": false,
    "created_at": "2017-04-28T19:58:58+00:00",
    "updated_at": "2018-04-30T19:58:58+00:00",
    "vat_accounting_method": "effective",
    "vat_accounting_type": "agreed"
  }
]
```

**422** — Validation error

**Request sample**:

```json
[
  {
    "field": "start",
    "value": "2018-01-01",
    "criteria": "="
  }
]
```

---

## `GET` `/3.0/accounting/calendar_years/{calendar_year_id}` — Fetch a calendar year

operationId: `ShowCalendarYear`

This action fetches a single calendar year

### path Parameters

| Parameter | Type | Description |
|---|---|---|
| calendar_year_id *(required)* | integer <int32> | the id of the calendar_year |

### Responses

200

**200** — OK

**Response samples** (200):

```json
{
  "id": 1,
  "start": "2018-01-01",
  "end": "2018-12-31",
  "is_vat_subject": true,
  "is_annual_reporting": false,
  "created_at": "2017-04-28T19:58:58+00:00",
  "updated_at": "2018-04-30T19:58:58+00:00",
  "vat_accounting_method": "effective",
  "vat_accounting_type": "agreed"
}
```

---
