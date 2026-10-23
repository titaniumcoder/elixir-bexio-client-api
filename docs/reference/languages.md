# Languages

Part of **Other endpoints**. Extracted from docs.bexio.com (snapshot Mon, 28 Sep 2026 12:05:15 GMT). 2 operations.

| Method | Path | Title |
|---|---|---|
| `GET` | `/2.0/language` | Fetch a list of languages |
| `POST` | `/2.0/language/search` | Search languages |

## `GET` `/2.0/language` — Fetch a list of languages

operationId: `v2ListLanguages`

This action fetches a list of all languages

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
    "name": "German",
    "decimal_point": ".",
    "thousands_separator": "'",
    "date_format_id": 1,
    "date_format": "d.m.Y",
    "iso_639_1": "de"
  }
]
```

---

## `POST` `/2.0/language/search` — Search languages

operationId: `v2SearchLanguages`

Search languages via query. Please refer to the Search section for detailed instructions.
The following search fields are supported:
- `name`
- `iso_639_1`

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
    "name": "German",
    "decimal_point": ".",
    "thousands_separator": "'",
    "date_format_id": 1,
    "date_format": "d.m.Y",
    "iso_639_1": "de"
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
