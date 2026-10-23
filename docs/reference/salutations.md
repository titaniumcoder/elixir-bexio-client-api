# Salutations

Part of **Contacts**. Extracted from docs.bexio.com (snapshot Mon, 28 Sep 2026 12:05:15 GMT). 6 operations.

| Method | Path | Title |
|---|---|---|
| `GET` | `/2.0/salutation` | Fetch a list of salutations |
| `POST` | `/2.0/salutation` | Create salutation |
| `POST` | `/2.0/salutation/search` | Search salutations |
| `GET` | `/2.0/salutation/{salutation_id}` | Fetch a salutation |
| `POST` | `/2.0/salutation/{salutation_id}` | Edit a salutation |
| `DELETE` | `/2.0/salutation/{salutation_id}` | Delete a salutation |

## `GET` `/2.0/salutation` — Fetch a list of salutations

operationId: `v2ListSalutations`

This action fetches a list of all salutations

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
    "name": "Herr"
  }
]
```

---

## `POST` `/2.0/salutation` — Create salutation

operationId: `v2CreateSalutation`

This action creates a new salutation

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
  "name": "Herr"
}
```

**422** — Validation error

**Request sample**:

```json
{
  "name": "Herr"
}
```

---

## `POST` `/2.0/salutation/search` — Search salutations

operationId: `v2SearchSalutations`

Search salutations via query. Please refer to the Search section for detailed instructions.
The following search fields are supported:
- `name`

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
    "name": "Herr"
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

## `GET` `/2.0/salutation/{salutation_id}` — Fetch a salutation

operationId: `v2ShowSalutation`

This action fetches a single salutation

### path Parameters

| Parameter | Type | Description |
|---|---|---|
| salutation_id *(required)* | integer <int32> | the id of the salutation |

### Responses

200

**200** — OK

**Response samples** (200):

```json
{
  "id": 1,
  "name": "Herr"
}
```

---

## `POST` `/2.0/salutation/{salutation_id}` — Edit a salutation

operationId: `v2EditSalutation`

This action edits a single salutation

### path Parameters

| Parameter | Type | Description |
|---|---|---|
| salutation_id *(required)* | integer <int32> | the id of the salutation |

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
  "name": "Herr"
}
```

**422** — Validation error

**Request sample**:

```json
{
  "name": "Herr"
}
```

---

## `DELETE` `/2.0/salutation/{salutation_id}` — Delete a salutation

operationId: `v2DeleteSalutation`

This action permanently deletes a salutation. It cannot be undone.

### path Parameters

| Parameter | Type | Description |
|---|---|---|
| salutation_id *(required)* | integer <int32> | the id of the salutation |

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
