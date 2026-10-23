# Contact Groups

Part of **Contacts**. Extracted from docs.bexio.com (snapshot Mon, 28 Sep 2026 12:05:15 GMT). 6 operations.

| Method | Path | Title |
|---|---|---|
| `GET` | `/2.0/contact_group` | Fetch a list of contact groups |
| `POST` | `/2.0/contact_group` | Create contact group |
| `POST` | `/2.0/contact_group/search` | Search contact groups |
| `GET` | `/2.0/contact_group/{contact_group_id}` | Fetch a contact group |
| `POST` | `/2.0/contact_group/{contact_group_id}` | Edit a contact group |
| `DELETE` | `/2.0/contact_group/{contact_group_id}` | Delete a contact group |

## `GET` `/2.0/contact_group` — Fetch a list of contact groups

operationId: `v2ListContactGroups`

This action fetches a list of all contact groups

### query Parameters

| Parameter | Type | Description |
|---|---|---|
| order_by | string Default: id Enum: id name | Defines the order of the results. Multiple sort parameters can be combined by using a comma separator. `_asc` and `_desc` can be appended to any parameter to either sort ascending (default) or descending. |
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
    "name": "Suppliers"
  }
]
```

---

## `POST` `/2.0/contact_group` — Create contact group

operationId: `v2CreateContactGroup`

This action creates a new contact group

### Request Body schema: application/json *(required)*

| Parameter | Type | Description |
|---|---|---|
| name *(required)* | string |  |

### Responses

201, 422

**201** — Created

**Response samples** (201):

```json
{
  "id": 1,
  "name": "Suppliers"
}
```

**422** — Validation error

**Request sample**:

```json
{
  "name": "Suppliers"
}
```

---

## `POST` `/2.0/contact_group/search` — Search contact groups

operationId: `v2SearchContactGroups`

Search contact groups via query. Please refer to the Search section for detailed instructions.
The following search fields are supported:
- `name`

### query Parameters

| Parameter | Type | Description |
|---|---|---|
| order_by | string Default: id Enum: id name | Defines the order of the results. Multiple sort parameters can be combined by using a comma separator. `_asc` and `_desc` can be appended to any parameter to either sort ascending (default) or descending. |
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
    "name": "Suppliers"
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

## `GET` `/2.0/contact_group/{contact_group_id}` — Fetch a contact group

operationId: `v2ShowContactGroup`

This action fetches a single contact group

### path Parameters

| Parameter | Type | Description |
|---|---|---|
| contact_group_id *(required)* | integer <int32> | the id of the contact group |

### Responses

200

**200** — OK

**Response samples** (200):

```json
{
  "id": 1,
  "name": "Suppliers"
}
```

---

## `POST` `/2.0/contact_group/{contact_group_id}` — Edit a contact group

operationId: `v2EditContactGroup`

This action edits a single contact group

### path Parameters

| Parameter | Type | Description |
|---|---|---|
| contact_group_id *(required)* | integer <int32> | the id of the contact group |

### Request Body schema: application/json

| Parameter | Type | Description |
|---|---|---|
| name *(required)* | string |  |

### Responses

200, 422

**200** — OK

**Response samples** (200):

```json
{
  "id": 1,
  "name": "Suppliers"
}
```

**422** — Validation error

**Request sample**:

```json
{
  "name": "Suppliers"
}
```

---

## `DELETE` `/2.0/contact_group/{contact_group_id}` — Delete a contact group

operationId: `v2DeleteContactGroup`

This action permanently deletes a contact group. It cannot be undone.

### path Parameters

| Parameter | Type | Description |
|---|---|---|
| contact_group_id *(required)* | integer <int32> | the id of the contact group |

### Responses

200

**200** — OK

**Response samples** (200):

```json
{
  "success": true
}
```

---
