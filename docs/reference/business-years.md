# Business Years

Part of **Accounting**. Extracted from docs.bexio.com (snapshot Mon, 28 Sep 2026 12:05:15 GMT). 2 operations.

| Method | Path | Title |
|---|---|---|
| `GET` | `/3.0/accounting/business_years` | Fetch a list of business years |
| `GET` | `/3.0/accounting/business_years/{business_year_id}` | Fetch a business year |

## `GET` `/3.0/accounting/business_years` — Fetch a list of business years

operationId: `ListBusinessYears`

This action fetches a list of all business years

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
    "status": "open",
    "closed_at": "2019-04-28"
  }
]
```

---

## `GET` `/3.0/accounting/business_years/{business_year_id}` — Fetch a business year

operationId: `ShowBusinessYear`

This action fetches a single business year

### path Parameters

| Parameter | Type | Description |
|---|---|---|
| business_year_id *(required)* | integer <int32> | the id of the business_year |

### Responses

200

**200** — OK

**Response samples** (200):

```json
{
  "id": 1,
  "start": "2018-01-01",
  "end": "2018-12-31",
  "status": "open",
  "closed_at": "2019-04-28"
}
```

---
