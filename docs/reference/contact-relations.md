# Contact Relations

Part of **Contacts**. Extracted from docs.bexio.com (snapshot Mon, 28 Sep 2026 12:05:15 GMT). 6 operations.

| Method | Path | Title |
|---|---|---|
| `GET` | `/2.0/contact_relation` | Fetch a list of contact relations |
| `POST` | `/2.0/contact_relation` | Create contact relation |
| `POST` | `/2.0/contact_relation/search` | Search contact relations |
| `GET` | `/2.0/contact_relation/{contact_relation_id}` | Fetch a contact relation |
| `POST` | `/2.0/contact_relation/{contact_relation_id}` | Edit a contact relation |
| `DELETE` | `/2.0/contact_relation/{contact_relation_id}` | Delete a contact relation |

## `GET` `/2.0/contact_relation` — Fetch a list of contact relations

operationId: `v2ListContactRelations`

This action fetches a list of all contact relations

### query Parameters

| Parameter | Type | Description |
|---|---|---|
| order_by | string Default: id Enum: id contact_id contact_sub_id updated_at | Defines the order of the results. Multiple sort parameters can be combined by using a comma separator. `_asc` and `_desc` can be appended to any parameter to either sort ascending (default) or descending. |
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
    "contact_id": 2,
    "contact_sub_id": 3,
    "description": "",
    "updated_at": "2019-04-08 13:17:32"
  }
]
```

---

## `POST` `/2.0/contact_relation` — Create contact relation

operationId: `v2CreateContactRelation`

This action creates a new contact relation

### Request Body schema: application/json *(required)*

| Parameter | Type | Description |
|---|---|---|
| contact_id *(required)* | integer or null | References a contact object |
| contact_sub_id *(required)* | integer or null | References a contact object |
| description | string or null |  |

### Responses

201, 422

**201** — Created

**Response samples** (201):

```json
{
  "id": 4,
  "nr": null,
  "contact_type_id": 1,
  "name_1": "Example Company",
  "name_2": null,
  "salutation_id": 2,
  "salutation_form": null,
  "title_id": null,
  "birthday": null,
  "address": "Smith Street 22",
  "street_name": "Smith Street",
  "house_number": "77",
  "address_addition": "Building C",
  "postcode": "8004",
  "city": "Zurich",
  "country_id": 1,
  "mail": "contact@example.org",
  "mail_second": "",
  "phone_fixed": "",
  "phone_fixed_second": "",
  "phone_mobile": "",
  "fax": "",
  "url": "",
  "skype_name": "",
  "remarks": "",
  "language_id": null,
  "is_lead": false,
  "contact_group_ids": "1,2",
  "contact_branch_ids": null,
  "user_id": 1,
  "owner_id": 1,
  "updated_at": "2019-04-08 13:17:32",
  "profile_image": "R0lGODlhAQABAIAAAAUEBAAAACwAAAAAAQABAAACAkQBADs="
}
```

**422** — Validation error

**Request sample**:

```json
{
  "contact_id": 2,
  "contact_sub_id": 3,
  "description": ""
}
```

---

## `POST` `/2.0/contact_relation/search` — Search contact relations

operationId: `v2SearchContactRelations`

Search contact relations via query. Please refer to the Search section for detailed instructions.
The following search fields are supported:
- `contact_id`
- `contact_sub_id`
- `updated_at`

### query Parameters

| Parameter | Type | Description |
|---|---|---|
| order_by | string Default: id Enum: id contact_id contact_sub_id updated_at | Defines the order of the results. Multiple sort parameters can be combined by using a comma separator. `_asc` and `_desc` can be appended to any parameter to either sort ascending (default) or descending. |
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
    "contact_id": 2,
    "contact_sub_id": 3,
    "description": "",
    "updated_at": "2019-04-08 13:17:32"
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

## `GET` `/2.0/contact_relation/{contact_relation_id}` — Fetch a contact relation

operationId: `v2ShowContactRelation`

This action fetches a single contact relation

### path Parameters

| Parameter | Type | Description |
|---|---|---|
| contact_relation_id *(required)* | integer <int32> | the id of the contact relation |

### Responses

200

**200** — OK

**Response samples** (200):

```json
{
  "id": 1,
  "contact_id": 2,
  "contact_sub_id": 3,
  "description": "",
  "updated_at": "2019-04-08 13:17:32"
}
```

---

## `POST` `/2.0/contact_relation/{contact_relation_id}` — Edit a contact relation

operationId: `v2EditContactRelation`

This action edits a single contact relation

### path Parameters

| Parameter | Type | Description |
|---|---|---|
| contact_relation_id *(required)* | integer <int32> | the id of the contact relation |

### Request Body schema: application/json

| Parameter | Type | Description |
|---|---|---|
| contact_id *(required)* | integer or null | References a contact object |
| contact_sub_id *(required)* | integer or null | References a contact object |
| description | string or null |  |

### Responses

200, 422

**200** — OK

**Response samples** (200):

```json
{
  "id": 1,
  "contact_id": 2,
  "contact_sub_id": 3,
  "description": "",
  "updated_at": "2019-04-08 13:17:32"
}
```

**422** — Validation error

**Request sample**:

```json
{
  "contact_id": 2,
  "contact_sub_id": 3,
  "description": ""
}
```

---

## `DELETE` `/2.0/contact_relation/{contact_relation_id}` — Delete a contact relation

operationId: `v2DeleteContactRelation`

This action permanently deletes a contact relation. It cannot be undone.

### path Parameters

| Parameter | Type | Description |
|---|---|---|
| contact_relation_id *(required)* | integer <int32> | the id of the contact relation |

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
