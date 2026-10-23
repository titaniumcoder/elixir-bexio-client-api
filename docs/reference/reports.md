# Reports

Part of **Accounting**. Extracted from docs.bexio.com (snapshot Mon, 28 Sep 2026 12:05:15 GMT). 1 operations.

| Method | Path | Title |
|---|---|---|
| `GET` | `/3.0/accounting/journal` | Journal |

## `GET` `/3.0/accounting/journal` — Journal

operationId: `ListJournalEntries`

This action fetches a list of all accounting journal bookings

### query Parameters

| Parameter | Type | Description |
|---|---|---|
| from | string <date> | Can be used to filter for entries after this date |
| to | string <date> | Can be used to filter for entries until this date |
| account_uuid | string | Can be used to filter for entries with account with uuid |
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
    "ref_id": 13,
    "ref_uuid": "456fc553-f42b-417e-a2af-dd5c5b9bade6",
    "ref_class": "KbInvoice",
    "date": "2019-02-17T00:00:00+02:00",
    "debit_account_id": 77,
    "credit_account_id": 139,
    "description": "Website for client Smith",
    "amount": 328.25,
    "currency_id": 1,
    "currency_factor": 1,
    "base_currency_id": 1,
    "base_currency_amount": 328.25
  }
]
```

---
