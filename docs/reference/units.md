# Units

Part of **Other endpoints**. Extracted from docs.bexio.com (snapshot Mon, 28 Sep 2026 12:05:15 GMT). 6 operations.

| Method | Path | Title |
|---|---|---|
| `GET` | `/2.0/unit` | Fetch a list of units |
| `POST` | `/2.0/unit` | Create unit |
| `POST` | `/2.0/unit/search` | Search units |
| `GET` | `/2.0/unit/{unit_id}` | Fetch a unit |
| `POST` | `/2.0/unit/{unit_id}` | Edit a unit |
| `DELETE` | `/2.0/unit/{unit_id}` | Delete a unit |

## `GET` `/2.0/unit` — Fetch a list of units

operationId: `v2ListUnits`

This action fetches a list of all units

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
    "name": "h"
  }
]
```

---

## `POST` `/2.0/unit` — Create unit

operationId: `v2CreateUnit`

This action creates a new unit

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
  "name": "h"
}
```

**422** — Validation error

**Request sample**:

```json
{
  "name": "h"
}
```

---

## `POST` `/2.0/unit/search` — Search units

operationId: `v2SearchUnits`

Search units via query. Please refer to the Search section for detailed instructions.
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
    "name": "h"
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

## `GET` `/2.0/unit/{unit_id}` — Fetch a unit

operationId: `v2ShowUnit`

This action fetches a single unit

### path Parameters

| Parameter | Type | Description |
|---|---|---|
| unit_id *(required)* | integer <int32> | the id of the unit |

### Responses

200

**200** — OK

**Response samples** (200):

```json
{
  "id": 1,
  "name": "h"
}
```

---

## `POST` `/2.0/unit/{unit_id}` — Edit a unit

operationId: `v2EditUnit`

This action edits a single unit

### path Parameters

| Parameter | Type | Description |
|---|---|---|
| unit_id *(required)* | integer <int32> | the id of the unit |

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
  "name": "h"
}
```

**422** — Validation error

**Request sample**:

```json
{
  "name": "h"
}
```

---

## `DELETE` `/2.0/unit/{unit_id}` — Delete a unit

operationId: `v2DeleteUnit`

This action permanently deletes a unit. It cannot be undone.

### path Parameters

| Parameter | Type | Description |
|---|---|---|
| unit_id *(required)* | integer <int32> | the id of the unit |

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
