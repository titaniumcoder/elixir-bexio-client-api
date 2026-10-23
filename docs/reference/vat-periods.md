# Vat Periods

Part of **Accounting**. Extracted from docs.bexio.com (snapshot Mon, 28 Sep 2026 12:05:15 GMT). 2 operations.

| Method | Path | Title |
|---|---|---|
| `GET` | `/3.0/accounting/vat_periods` | Fetch a list of vat periods |
| `GET` | `/3.0/accounting/vat_periods/{vat_period_id}` | Fetch a vat period |

## `GET` `/3.0/accounting/vat_periods` — Fetch a list of vat periods

operationId: `ListVatPeriods`

This action fetches a list of all vat periods

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
    "end": "2018-03-31",
    "type": "quarter",
    "status": "closed",
    "closed_at": "2018-04-28"
  }
]
```

---

## `GET` `/3.0/accounting/vat_periods/{vat_period_id}` — Fetch a vat period

operationId: `ShowVatPeriod`

This action fetches a single vat period

### path Parameters

| Parameter | Type | Description |
|---|---|---|
| vat_period_id *(required)* | integer <int32> | the id of the vat_period |

### Responses

200

**200** — OK

**Response samples** (200):

```json
{
  "id": 1,
  "start": "2018-01-01",
  "end": "2018-03-31",
  "type": "quarter",
  "status": "closed",
  "closed_at": "2018-04-28"
}
```

---
