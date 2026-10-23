# Titles

Part of **Contacts**. Extracted from docs.bexio.com (snapshot Mon, 28 Sep 2026 12:05:15 GMT). 6 operations.

| Method | Path | Title |
|---|---|---|
| `GET` | `/2.0/title` | Fetch a list of titles |
| `POST` | `/2.0/title` | Create title |
| `POST` | `/2.0/title/search` | Search titles |
| `GET` | `/2.0/title/{title_id}` | Fetch a title |
| `POST` | `/2.0/title/{title_id}` | Edit a title |
| `DELETE` | `/2.0/title/{title_id}` | Delete a title |

## `GET` `/2.0/title` — Fetch a list of titles

operationId: `v2ListTitles`

This action fetches a list of all titles

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
    "name": "Dr."
  }
]
```

---

## `POST` `/2.0/title` — Create title

operationId: `v2CreateTitle`

This action creates a new title

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
  "name": "Dr."
}
```

**422** — Validation error

**Request sample**:

```json
{
  "name": "Dr."
}
```

---

## `POST` `/2.0/title/search` — Search titles

operationId: `v2SearchTitles`

Search titles via query. Please refer to the Search section for detailed instructions.
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
    "name": "Dr."
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

## `GET` `/2.0/title/{title_id}` — Fetch a title

operationId: `v2ShowTitle`

This action fetches a single title

### path Parameters

| Parameter | Type | Description |
|---|---|---|
| title_id *(required)* | integer <int32> | the id of the title |

### Responses

200

**200** — OK

**Response samples** (200):

```json
{
  "id": 1,
  "name": "Dr."
}
```

---

## `POST` `/2.0/title/{title_id}` — Edit a title

operationId: `v2EditTitle`

This action edits a single title

### path Parameters

| Parameter | Type | Description |
|---|---|---|
| title_id *(required)* | integer <int32> | the id of the title |

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
  "name": "Dr."
}
```

**422** — Validation error

**Request sample**:

```json
{
  "name": "Dr."
}
```

---

## `DELETE` `/2.0/title/{title_id}` — Delete a title

operationId: `v2DeleteTitle`

This action permanently deletes a title. It cannot be undone.

### path Parameters

| Parameter | Type | Description |
|---|---|---|
| title_id *(required)* | integer <int32> | the id of the title |

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
