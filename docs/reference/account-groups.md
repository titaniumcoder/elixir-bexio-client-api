# Account Groups

Part of **Accounting**. Extracted from docs.bexio.com (snapshot Mon, 28 Sep 2026 12:05:15 GMT). 1 operations.

| Method | Path | Title |
|---|---|---|
| `GET` | `/2.0/account_groups` | Fetch a list of account groups |

## `GET` `/2.0/account_groups` — Fetch a list of account groups

operationId: `v2ListAccountGroups`

This action fetches a list of all account groups

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
    "uuid": "5fe93c8a-b05f-4004-91f5-9177ffd011fd",
    "account_no": "1",
    "name": "Assets",
    "parent_fibu_account_group_id": 3,
    "is_active": true,
    "is_locked": false
  }
]
```

---
