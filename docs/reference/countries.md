# Countries

Part of **Other endpoints**. Extracted from docs.bexio.com (snapshot Mon, 28 Sep 2026 12:05:15 GMT). 6 operations.

| Method | Path | Title |
|---|---|---|
| `GET` | `/2.0/country` | Fetch a list of countries |
| `POST` | `/2.0/country` | Create country |
| `POST` | `/2.0/country/search` | Search countries |
| `GET` | `/2.0/country/{country_id}` | Fetch a country |
| `POST` | `/2.0/country/{country_id}` | Edit a country |
| `DELETE` | `/2.0/country/{country_id}` | Delete a country |

## `GET` `/2.0/country` — Fetch a list of countries

operationId: `v2ListCountries`

This action fetches a list of all countries

### query Parameters

| Parameter | Type | Description |
|---|---|---|
| order_by | string Default: id Enum: id name name_short | Defines the order of the results. Multiple sort parameters can be combined by using a comma separator. `_asc` and `_desc` can be appended to any parameter to either sort ascending (default) or descending. |
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
    "name": "Kiribati",
    "name_short": "KI",
    "iso3166_alpha2": "KI"
  }
]
```

---

## `POST` `/2.0/country` — Create country

operationId: `v2CreateCountry`

This action creates a new country

### Request Body schema: application/json *(required)*

| Parameter | Type | Description |
|---|---|---|
| name *(required)* | string |  |
| name_short *(required)* | string |  |
| iso3166_alpha2 *(required)* | string |  |

### Responses

201, 422

**201** — Created

**Response samples** (201):

```json
{
  "id": 1,
  "name": "Kiribati",
  "name_short": "KI",
  "iso3166_alpha2": "KI"
}
```

**422** — Validation error

**Request sample**:

```json
{
  "name": "Kiribati",
  "name_short": "KI",
  "iso3166_alpha2": "KI"
}
```

---

## `POST` `/2.0/country/search` — Search countries

operationId: `v2SearchCountries`

Search countries via query. Please refer to the Search section for detailed instructions.
The following search fields are supported:
- `name`
- `name_short`

### query Parameters

| Parameter | Type | Description |
|---|---|---|
| order_by | string Default: id Enum: id name name_short | Defines the order of the results. Multiple sort parameters can be combined by using a comma separator. `_asc` and `_desc` can be appended to any parameter to either sort ascending (default) or descending. |
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
    "name": "Kiribati",
    "name_short": "KI",
    "iso3166_alpha2": "KI"
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

## `GET` `/2.0/country/{country_id}` — Fetch a country

operationId: `v2ShowCountry`

This action fetches a single country

### path Parameters

| Parameter | Type | Description |
|---|---|---|
| country_id *(required)* | integer <int32> | the id of the country |

### Responses

200

**200** — OK

**Response samples** (200):

```json
{
  "id": 1,
  "name": "Kiribati",
  "name_short": "KI",
  "iso3166_alpha2": "KI"
}
```

---

## `POST` `/2.0/country/{country_id}` — Edit a country

operationId: `v2EditCountry`

This action edits a single country

### path Parameters

| Parameter | Type | Description |
|---|---|---|
| country_id *(required)* | integer <int32> | the id of the country |

### Request Body schema: application/json

| Parameter | Type | Description |
|---|---|---|
| name *(required)* | string |  |
| name_short *(required)* | string |  |
| iso3166_alpha2 *(required)* | string |  |

### Responses

200, 422

**200** — OK

**Response samples** (200):

```json
{
  "id": 1,
  "name": "Kiribati",
  "name_short": "KI",
  "iso3166_alpha2": "KI"
}
```

**422** — Validation error

**Request sample**:

```json
{
  "name": "Kiribati",
  "name_short": "KI",
  "iso3166_alpha2": "KI"
}
```

---

## `DELETE` `/2.0/country/{country_id}` — Delete a country

operationId: `DeleteCountry`

This action permanently deletes a country. It cannot be undone.

### path Parameters

| Parameter | Type | Description |
|---|---|---|
| country_id *(required)* | integer <int32> | the id of the country |

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
