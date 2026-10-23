# Contacts

Part of **Contacts**. Extracted from docs.bexio.com (snapshot Mon, 28 Sep 2026 12:05:15 GMT). 8 operations.

| Method | Path | Title |
|---|---|---|
| `GET` | `/2.0/contact` | Fetch a list of contacts |
| `POST` | `/2.0/contact` | Create contact |
| `POST` | `/2.0/contact/search` | Search contacts |
| `GET` | `/2.0/contact/{contact_id}` | Fetch a contact |
| `POST` | `/2.0/contact/{contact_id}` | Edit a contact |
| `DELETE` | `/2.0/contact/{contact_id}` | Delete a contact |
| `POST` | `/2.0/contact/_bulk_create` | Bulk create contacts |
| `PATCH` | `/2.0/contact/{contact_id}/restore` | Restore a contact |

## `GET` `/2.0/contact` — Fetch a list of contacts

operationId: `v2ListContacts`

This action fetches a list of all contacts

### query Parameters

| Parameter | Type | Description |
|---|---|---|
| order_by | string Default: id Enum: id nr name_1 updated_at | Defines the order of the results. Multiple sort parameters can be combined by using a comma separator. `_asc` and `_desc` can be appended to any parameter to either sort ascending (default) or descending. |
| limit | integer <int32> Default: 500 | Limit the number of results (max is 2000) |
| offset | integer <int32> Default: 0 | Skip over a number of elements by specifying an offset value for the query |
| show_archived | boolean Default: False | Show archived elements only |

### Responses

200

**200** — OK

**Response samples** (200):

```json
[
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
    "updated_at": "2019-04-08 13:17:32"
  }
]
```

---

## `POST` `/2.0/contact` — Create contact

operationId: `v2CreateContact`

This action creates a new contact

### Request Body schema: application/json *(required)*

| Parameter | Type | Description |
|---|---|---|
| nr | string or null | If set to null, the number will be assigned automatically. Must be a number, can also be used as integer |
| contact_type_id *(required)* | integer | Please use the value `1` for companies or `2` for persons |
| name_1 *(required)* | string | This field is used as the company name if the field `contact_type_id` is set to `1`. Otherwise, the field is used as the last name of the person |
| name_2 | string or null | This field is used as the company addition if the field `contact_type_id` is set to `1`. Otherwise, the field is used as the first name of the person |
| salutation_id | integer or null | References a salutation object |
| salutation_form | integer or null |  |
| title_id | integer or null | References a title object |
| birthday | string <date> or null |  |
| street_name | string or null | Is required if `house_number` or `address_addition` are not NULL |
| house_number | string or null | Requires `street_name` if the value is not NULL |
| address_addition | string or null | Requires `street_name` if the value is not NULL |
| postcode | string or null |  |
| city | string or null |  |
| country_id | integer or null | References a country object |
| mail | string or null |  |
| mail_second | string or null |  |
| phone_fixed | string or null |  |
| phone_fixed_second | string or null |  |
| phone_mobile | string or null |  |
| fax | string or null |  |
| url | string or null |  |
| skype_name | string or null |  |
| remarks | string or null |  |
| language_id | integer or null | References a language object |
| contact_group_ids | string or null | References one ore multiple contact group objects |
| contact_branch_ids | string or null | References one ore multiple contact sector objects |
| user_id *(required)* | integer | References a user object |
| owner_id *(required)* | integer |  |

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
  "nr": null,
  "contact_type_id": 1,
  "name_1": "Example Company",
  "name_2": null,
  "salutation_id": 2,
  "salutation_form": null,
  "title_id": null,
  "birthday": null,
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
  "contact_group_ids": "1,2",
  "contact_branch_ids": null,
  "user_id": 1,
  "owner_id": 1
}
```

---

## `POST` `/2.0/contact/search` — Search contacts

operationId: `v2SearchContact`

Search contacts via query. Please refer to the Search section for detailed instructions.
The following search fields are supported:
- `id`
- `name_1`
- `name_2`
- `nr`
- `address`
- `mail`
- `mail_second`
- `postcode`
- `city`
- `country_id`
- `contact_group_ids`
- `contact_type_id`
- `updated_at`
- `user_id`
- `phone_fixed`
- `phone_mobile`
- `fax`

### query Parameters

| Parameter | Type | Description |
|---|---|---|
| order_by | string Default: id Enum: id nr name_1 updated_at | Defines the order of the results. Multiple sort parameters can be combined by using a comma separator. `_asc` and `_desc` can be appended to any parameter to either sort ascending (default) or descending. |
| limit | integer <int32> Default: 500 | Limit the number of results (max is 2000) |
| offset | integer <int32> Default: 0 | Skip over a number of elements by specifying an offset value for the query |
| show_archived | boolean Default: False | Show archived elements only |

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

## `GET` `/2.0/contact/{contact_id}` — Fetch a contact

operationId: `v2ShowContact`

This action fetches a single contact

### path Parameters

| Parameter | Type | Description |
|---|---|---|
| contact_id *(required)* | integer <int32> | the id of the contact |

### query Parameters

| Parameter | Type | Description |
|---|---|---|
| show_archived | boolean Default: False | Show archived elements only |

### Responses

200

**200** — OK

**Response samples** (200):

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

---

## `POST` `/2.0/contact/{contact_id}` — Edit a contact

operationId: `v2EditContact`

This action edits a single contact

### path Parameters

| Parameter | Type | Description |
|---|---|---|
| contact_id *(required)* | integer <int32> | the id of the contact |

### Request Body schema: application/json

| Parameter | Type | Description |
|---|---|---|
| nr | string or null | If set to null, the number will be assigned automatically. Must be a number, can also be used as integer |
| contact_type_id *(required)* | integer | Please use the value `1` for companies or `2` for persons |
| name_1 *(required)* | string | This field is used as the company name if the field `contact_type_id` is set to `1`. Otherwise, the field is used as the last name of the person |
| name_2 | string or null | This field is used as the company addition if the field `contact_type_id` is set to `1`. Otherwise, the field is used as the first name of the person |
| salutation_id | integer or null | References a salutation object |
| salutation_form | integer or null |  |
| title_id | integer or null | References a title object |
| birthday | string <date> or null |  |
| street_name | string or null | Is required if `house_number` or `address_addition` are not NULL |
| house_number | string or null | Requires `street_name` if the value is not NULL |
| address_addition | string or null | Requires `street_name` if the value is not NULL |
| postcode | string or null |  |
| city | string or null |  |
| country_id | integer or null | References a country object |
| mail | string or null |  |
| mail_second | string or null |  |
| phone_fixed | string or null |  |
| phone_fixed_second | string or null |  |
| phone_mobile | string or null |  |
| fax | string or null |  |
| url | string or null |  |
| skype_name | string or null |  |
| remarks | string or null |  |
| language_id | integer or null | References a language object |
| contact_group_ids | string or null | References one ore multiple contact group objects |
| contact_branch_ids | string or null | References one ore multiple contact sector objects |
| user_id *(required)* | integer | References a user object |
| owner_id *(required)* | integer |  |

### Responses

200, 422

**200** — OK

**Response samples** (200):

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
  "nr": null,
  "contact_type_id": 1,
  "name_1": "Example Company",
  "name_2": null,
  "salutation_id": 2,
  "salutation_form": null,
  "title_id": null,
  "birthday": null,
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
  "contact_group_ids": "1,2",
  "contact_branch_ids": null,
  "user_id": 1,
  "owner_id": 1
}
```

---

## `DELETE` `/2.0/contact/{contact_id}` — Delete a contact

operationId: `v2DeleteContact`

This action deletes a contact. Please note that a contact is marked as deleted and can still be accessed by using the "show deleted contacts" filter.

### path Parameters

| Parameter | Type | Description |
|---|---|---|
| contact_id *(required)* | integer <int32> | the id of the contact |

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

## `POST` `/2.0/contact/_bulk_create` — Bulk create contacts

operationId: `v2BulkCreateContacts`

This action creates multiple contacts in one request

### Request Body schema: application/json

| Parameter | Type | Description |
|---|---|---|
| nr | string or null | If set to null, the number will be assigned automatically. Must be a number, can also be used as integer |
| contact_type_id *(required)* | integer | Please use the value `1` for companies or `2` for persons |
| name_1 *(required)* | string | This field is used as the company name if the field `contact_type_id` is set to `1`. Otherwise, the field is used as the last name of the person |
| name_2 | string or null | This field is used as the company addition if the field `contact_type_id` is set to `1`. Otherwise, the field is used as the first name of the person |
| salutation_id | integer or null | References a salutation object |
| salutation_form | integer or null |  |
| title_id | integer or null | References a title object |
| birthday | string <date> or null |  |
| street_name | string or null | Is required if `house_number` or `address_addition` are not NULL |
| house_number | string or null | Requires `street_name` if the value is not NULL |
| address_addition | string or null | Requires `street_name` if the value is not NULL |
| postcode | string or null |  |
| city | string or null |  |
| country_id | integer or null | References a country object |
| mail | string or null |  |
| mail_second | string or null |  |
| phone_fixed | string or null |  |
| phone_fixed_second | string or null |  |
| phone_mobile | string or null |  |
| fax | string or null |  |
| url | string or null |  |
| skype_name | string or null |  |
| remarks | string or null |  |
| language_id | integer or null | References a language object |
| contact_group_ids | string or null | References one ore multiple contact group objects |
| contact_branch_ids | string or null | References one ore multiple contact sector objects |
| user_id *(required)* | integer | References a user object |
| owner_id *(required)* | integer |  |

### Responses

200, 422

**200** — OK

**Response samples** (200):

```json
[
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
    "updated_at": "2019-04-08 13:17:32"
  }
]
```

**422** — Validation error

**Request sample**:

```json
[
  {
    "nr": null,
    "contact_type_id": 1,
    "name_1": "Example Company",
    "name_2": null,
    "salutation_id": 2,
    "salutation_form": null,
    "title_id": null,
    "birthday": null,
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
    "contact_group_ids": "1,2",
    "contact_branch_ids": null,
    "user_id": 1,
    "owner_id": 1
  }
]
```

---

## `PATCH` `/2.0/contact/{contact_id}/restore` — Restore a contact

operationId: `v2RestoreContact`

This action restores an archived contact.

### path Parameters

| Parameter | Type | Description |
|---|---|---|
| contact_id *(required)* | integer <int32> | the id of the contact |

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
