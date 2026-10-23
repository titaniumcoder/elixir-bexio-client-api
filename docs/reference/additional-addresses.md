# Additional Addresses

Part of **Contacts**. Extracted from docs.bexio.com (snapshot Mon, 28 Sep 2026 12:05:15 GMT). 6 operations.

| Method | Path | Title |
|---|---|---|
| `GET` | `/2.0/contact/{contact_id}/additional_address` | Fetch a list of additional addresses |
| `POST` | `/2.0/contact/{contact_id}/additional_address` | Create additional address |
| `POST` | `/2.0/contact/{contact_id}/additional_address/search` | Search additional addresses |
| `GET` | `/2.0/contact/{contact_id}/additional_address/{additional_address_id}` | Fetch an additional address |
| `POST` | `/2.0/contact/{contact_id}/additional_address/{additional_address_id}` | Edit an additional address |
| `DELETE` | `/2.0/contact/{contact_id}/additional_address/{additional_address_id}` | Delete an additional address |

## `GET` `/2.0/contact/{contact_id}/additional_address` — Fetch a list of additional addresses

operationId: `v2ListAdditionalAddresses`

This action fetches a list of all additional addresses for a given contact

### path Parameters

| Parameter | Type | Description |
|---|---|---|
| contact_id *(required)* | integer <int32> | the id of the contact |

### query Parameters

| Parameter | Type | Description |
|---|---|---|
| order_by | string Default: id Enum: id name postcode country_id | Defines the order of the results. Multiple sort parameters can be combined by using a comma separator. `_asc` and `_desc` can be appended to any parameter to either sort ascending (default) or descending. |
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
    "name": "My new address",
    "name_addition": "Name addition",
    "address": "Walter Street 22",
    "street_name": "Walter Street",
    "house_number": "22",
    "address_addition": "Building C",
    "postcode": "9000",
    "city": "St. Gallen",
    "country_id": 1,
    "subject": "Additional address",
    "description": "This is an internal description"
  }
]
```

---

## `POST` `/2.0/contact/{contact_id}/additional_address` — Create additional address

operationId: `v2CreateAdditionalAddress`

This action creates a new additional address

### path Parameters

| Parameter | Type | Description |
|---|---|---|
| contact_id *(required)* | integer <int32> | the id of the contact |

### Request Body schema: application/json *(required)*

| Parameter | Type | Description |
|---|---|---|
| name | string |  |
| name_addition | string or null |  |
| street_name | string or null | Is required if `house_number` or `address_addition` are not NULL |
| house_number | string or null | Requires `street_name` if the value is not NULL |
| address_addition | string or null | Requires `street_name` if the value is not NULL |
| postcode | string or null |  |
| city | string or null |  |
| country_id | integer or null | References a country object |
| subject | string |  |
| description | string |  |

### Responses

201, 422

**201** — Created

**Response samples** (201):

```json
{
  "id": 1,
  "name": "My new address",
  "name_addition": "Name addition",
  "address": "Walter Street 22",
  "street_name": "Walter Street",
  "house_number": "22",
  "address_addition": "Building C",
  "postcode": "9000",
  "city": "St. Gallen",
  "country_id": 1,
  "subject": "Additional address",
  "description": "This is an internal description"
}
```

**422** — Validation error

**Request sample**:

```json
{
  "name": "My new address",
  "name_addition": "Name addition",
  "street_name": "Walter Street",
  "house_number": "22",
  "address_addition": "Building C",
  "postcode": "9000",
  "city": "St. Gallen",
  "country_id": 1,
  "subject": "Additional address",
  "description": "This is an internal description"
}
```

---

## `POST` `/2.0/contact/{contact_id}/additional_address/search` — Search additional addresses

operationId: `v2SearchAdditionalAddresses`

Search additional addresses via query. Please refer to the Search section for detailed instructions.
The following search fields are supported:
- `name`
- `address`
- `postcode`
- `city`
- `country_id`
- `subject`
- `email`

### path Parameters

| Parameter | Type | Description |
|---|---|---|
| contact_id *(required)* | integer <int32> | the id of the contact |

### query Parameters

| Parameter | Type | Description |
|---|---|---|
| order_by | string Default: id Enum: id name postcode country_id | Defines the order of the results. Multiple sort parameters can be combined by using a comma separator. `_asc` and `_desc` can be appended to any parameter to either sort ascending (default) or descending. |
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
    "name": "My new address",
    "name_addition": "Name addition",
    "address": "Walter Street 22",
    "street_name": "Walter Street",
    "house_number": "22",
    "address_addition": "Building C",
    "postcode": "9000",
    "city": "St. Gallen",
    "country_id": 1,
    "subject": "Additional address",
    "description": "This is an internal description"
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

## `GET` `/2.0/contact/{contact_id}/additional_address/{additional_address_id}` — Fetch an additional address

operationId: `v2ShowAdditionalAddress`

This action fetches an additional address for a given contact

### path Parameters

| Parameter | Type | Description |
|---|---|---|
| contact_id *(required)* | integer <int32> | the id of the contact |
| additional_address_id *(required)* | integer <int32> | the id of the additional address |

### Responses

200

**200** — OK

**Response samples** (200):

```json
{
  "id": 1,
  "name": "My new address",
  "name_addition": "Name addition",
  "address": "Walter Street 22",
  "street_name": "Walter Street",
  "house_number": "22",
  "address_addition": "Building C",
  "postcode": "9000",
  "city": "St. Gallen",
  "country_id": 1,
  "subject": "Additional address",
  "description": "This is an internal description"
}
```

---

## `POST` `/2.0/contact/{contact_id}/additional_address/{additional_address_id}` — Edit an additional address

operationId: `v2EditAdditionalAddress`

This action edits an additional address

### path Parameters

| Parameter | Type | Description |
|---|---|---|
| contact_id *(required)* | integer <int32> | the id of the contact |
| additional_address_id *(required)* | integer <int32> | the id of the additional address |

### Request Body schema: application/json

| Parameter | Type | Description |
|---|---|---|
| name | string |  |
| name_addition | string or null |  |
| street_name | string or null | Is required if `house_number` or `address_addition` are not NULL |
| house_number | string or null | Requires `street_name` if the value is not NULL |
| address_addition | string or null | Requires `street_name` if the value is not NULL |
| postcode | string or null |  |
| city | string or null |  |
| country_id | integer or null | References a country object |
| subject | string |  |
| description | string |  |

### Responses

200, 422

**200** — OK

**Response samples** (200):

```json
{
  "id": 1,
  "name": "My new address",
  "name_addition": "Name addition",
  "address": "Walter Street 22",
  "street_name": "Walter Street",
  "house_number": "22",
  "address_addition": "Building C",
  "postcode": "9000",
  "city": "St. Gallen",
  "country_id": 1,
  "subject": "Additional address",
  "description": "This is an internal description"
}
```

**422** — Validation error

**Request sample**:

```json
{
  "name": "My new address",
  "name_addition": "Name addition",
  "street_name": "Walter Street",
  "house_number": "22",
  "address_addition": "Building C",
  "postcode": "9000",
  "city": "St. Gallen",
  "country_id": 1,
  "subject": "Additional address",
  "description": "This is an internal description"
}
```

---

## `DELETE` `/2.0/contact/{contact_id}/additional_address/{additional_address_id}` — Delete an additional address

operationId: `v2DeleteAdditionalAddress`

This action permanently deletes an additional address. It cannot be undone.

### path Parameters

| Parameter | Type | Description |
|---|---|---|
| contact_id *(required)* | integer <int32> | the id of the contact |
| additional_address_id *(required)* | integer <int32> | the id of the additional address |

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
