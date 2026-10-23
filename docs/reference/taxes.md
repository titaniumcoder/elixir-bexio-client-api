# Taxes

Part of **Accounting**. Extracted from docs.bexio.com (snapshot Mon, 28 Sep 2026 12:05:15 GMT). 3 operations.

| Method | Path | Title |
|---|---|---|
| `GET` | `/3.0/taxes` | Fetch a list of taxes |
| `GET` | `/3.0/taxes/{tax_id}` | Fetch a tax |
| `DELETE` | `/3.0/taxes/{tax_id}` | Delete a tax |

## `GET` `/3.0/taxes` — Fetch a list of taxes

operationId: `ListTaxes`

This action fetches a list of all taxes

### query Parameters

| Parameter | Type | Description |
|---|---|---|
| scope | string Enum: active inactive | Can be used to filter for active or inactive taxes |
| date | string <date> | Displays all taxes which are active at the date given |
| types | string Enum: sales_tax pre_tax | Filter the types of the tax |
| limit | integer <int32> Default: 500 | Limit the number of results (max is 2000) |
| offset | integer <int32> Default: 0 | Skip over a number of elements by specifying an offset value for the query |

### Responses

200, 422

**200** — OK

**Response samples** (200):

```json
[
  {
    "id": 1,
    "uuid": "8078b1f3-f85b-4adf-aaa8-c3eeea964927",
    "name": "lib.model.tax.ch.sales_7_7.name",
    "code": "UN77",
    "digit": "302",
    "type": "sales_tax",
    "account_id": 98,
    "tax_settlement_type": "none",
    "value": 7.7,
    "net_tax_value": null,
    "start_year": 2017,
    "end_year": 2018,
    "is_active": true,
    "display_name": "ZOLLM  - Import Mat/SV 100.00%",
    "start_month": 1,
    "end_month": 12
  }
]
```

**422** — Validation error

---

## `GET` `/3.0/taxes/{tax_id}` — Fetch a tax

operationId: `ShowTax`

This action fetches a single tax

### path Parameters

| Parameter | Type | Description |
|---|---|---|
| tax_id *(required)* | integer <int32> | the id of the tax |

### Responses

200

**200** — OK

**Response samples** (200):

```json
{
  "id": 1,
  "uuid": "8078b1f3-f85b-4adf-aaa8-c3eeea964927",
  "name": "lib.model.tax.ch.sales_7_7.name",
  "code": "UN77",
  "digit": "302",
  "type": "sales_tax",
  "account_id": 98,
  "tax_settlement_type": "none",
  "value": 7.7,
  "net_tax_value": null,
  "start_year": 2017,
  "end_year": 2018,
  "is_active": true,
  "display_name": "ZOLLM  - Import Mat/SV 100.00%",
  "start_month": 1,
  "end_month": 12
}
```

---

## `DELETE` `/3.0/taxes/{tax_id}` — Delete a tax

operationId: `DeleteTax`

This action permanently deletes a tax. It cannot be undone. Please note that taxes which are used and/or referenced within bexio, and taxes assigned to the digit 000 can not be deleted. In that case, the API will throw a 409 error.

### path Parameters

| Parameter | Type | Description |
|---|---|---|
| tax_id *(required)* | integer <int32> | the id of the tax |

### Responses

200, 409

**200** — OK

**Response samples** (200):

```json
{
  "success": true
}
```

**409** — Conflict

---
