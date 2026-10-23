# Accounts

Part of **Accounting**. Extracted from docs.bexio.com (snapshot Mon, 28 Sep 2026 12:05:15 GMT). 2 operations.

| Method | Path | Title |
|---|---|---|
| `GET` | `/2.0/accounts` | Fetch a list of accounts |
| `POST` | `/2.0/accounts/search` | Search Accounts |

## `GET` `/2.0/accounts` — Fetch a list of accounts

operationId: `v2ListAccounts`

This action fetches a list of all accounts

### query Parameters

| Parameter | Type | Description |
|---|---|---|
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
    "uuid": "c7da5b70-2d27-467e-abd9-9c3ac0f83c7d",
    "account_no": "3201",
    "name": "Gross proceeds credit sales",
    "account_type": 1,
    "tax_id": 40,
    "fibu_account_group_id": 65,
    "is_active": true,
    "is_locked": false
  }
]
```

**422** — Validation error

---

## `POST` `/2.0/accounts/search` — Search Accounts

operationId: `v2SearchAccounts`

Search accounts via query. Please refer to the Search section for detailed instructions.
The following search fields are supported:
- `account_no`
- `fibu_account_group_id`
- `name`
- `account_type`

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
| criteria | string Default: like Enum: = equal != not_equal > greater_than >= greater_equal < less_than <= less_equal like not_like is_null not_null in not_in |  |

### Responses

200, 422

**200** — OK

**Response samples** (200):

```json
[
  {
    "id": 1,
    "uuid": "c7da5b70-2d27-467e-abd9-9c3ac0f83c7d",
    "account_no": "3201",
    "name": "Gross proceeds credit sales",
    "account_type": 1,
    "tax_id": 40,
    "fibu_account_group_id": 65,
    "is_active": true,
    "is_locked": false
  }
]
```

**422** — Validation error

**Request sample**:

```json
[
  {
    "field": "search_field",
    "value": "search term",
    "criteria": "="
  }
]
```

---
