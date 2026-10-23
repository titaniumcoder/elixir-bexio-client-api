# Bank Accounts

Part of **Banking**. Extracted from docs.bexio.com (snapshot Mon, 28 Sep 2026 12:05:15 GMT). 2 operations.

| Method | Path | Title |
|---|---|---|
| `GET` | `/3.0/banking/accounts` | Fetch a list of bank accounts |
| `GET` | `/3.0/banking/accounts/{bank_account_id}` | Fetch a single bank account |

## `GET` `/3.0/banking/accounts` — Fetch a list of bank accounts

operationId: `ListBankAccounts`

This action fetches a list of all bank accounts which are shown on the banking component page

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
    "id": 4,
    "name": "UBS",
    "owner": "Metzgerei Schneider",
    "owner_address": "Alte Jonastrasse 10",
    "owner_house_number": 10,
    "owner_zip": 8640,
    "owner_city": "Rapperswil",
    "owner_country_code": "CH",
    "bc_nr": 250,
    "bank_name": "UBS Switzerland AG",
    "bank_nr": "UBSWCHZH86M",
    "bank_account_nr": "25010367101Y",
    "iban_nr": "CH560025025010367101Y",
    "currency_id": 1,
    "account_id": 77,
    "remarks": "This is an additional description",
    "invoice_mode": "qr_invoice",
    "qr_invoice_iban": "CH4431999123000889012",
    "type": "bank"
  }
]
```

---

## `GET` `/3.0/banking/accounts/{bank_account_id}` — Fetch a single bank account

operationId: `ShowBankAccount`

This action fetches a single bank account which is shown on the banking component page

### path Parameters

| Parameter | Type | Description |
|---|---|---|
| bank_account_id *(required)* | integer <int32> | ID of bank account to return |

### Responses

200

**200** — OK

**Response samples** (200):

```json
{
  "id": 4,
  "name": "UBS",
  "owner": "Metzgerei Schneider",
  "owner_address": "Alte Jonastrasse 10",
  "owner_house_number": 10,
  "owner_zip": 8640,
  "owner_city": "Rapperswil",
  "owner_country_code": "CH",
  "bc_nr": 250,
  "bank_name": "UBS Switzerland AG",
  "bank_nr": "UBSWCHZH86M",
  "bank_account_nr": "25010367101Y",
  "iban_nr": "CH560025025010367101Y",
  "currency_id": 1,
  "account_id": 77,
  "remarks": "This is an additional description",
  "invoice_mode": "qr_invoice",
  "qr_invoice_iban": "CH4431999123000889012",
  "type": "bank"
}
```

---
