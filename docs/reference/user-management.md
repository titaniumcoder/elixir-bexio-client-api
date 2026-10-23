# User Management

Part of **Other endpoints**. Extracted from docs.bexio.com (snapshot Mon, 28 Sep 2026 12:05:15 GMT). 8 operations.

| Method | Path | Title |
|---|---|---|
| `GET` | `/3.0/users` | Fetch a list of users |
| `GET` | `/3.0/users/{user_id}` | Fetch a user |
| `GET` | `/3.0/users/me` | Fetch the authenticated user |
| `GET` | `/3.0/fictional_users` | Fetch a list of fictional users |
| `POST` | `/3.0/fictional_users` | Create a fictional user |
| `GET` | `/3.0/fictional_users/{fictional_user_id}` | Fetch a fictional User |
| `DELETE` | `/3.0/fictional_users/{fictional_user_id}` | Delete a fictional user |
| `PATCH` | `/3.0/fictional_users/{fictional_user_id}` | Update a fictional User |

## `GET` `/3.0/users` — Fetch a list of users

operationId: `v3ListUsers`

This action fetches a list of all users

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
    "id": 4,
    "salutation_type": "male",
    "firstname": "Rudolph",
    "lastname": "Smith",
    "email": "rudolph.smith@example.com",
    "is_superadmin": true,
    "is_accountant": false
  }
]
```

---

## `GET` `/3.0/users/{user_id}` — Fetch a user

operationId: `v3ShowUser`

This action fetches a single user

### path Parameters

| Parameter | Type | Description |
|---|---|---|
| user_id *(required)* | integer <int32> | the id of the user |

### Responses

200

**200** — OK

**Response samples** (200):

```json
{
  "id": 4,
  "salutation_type": "male",
  "firstname": "Rudolph",
  "lastname": "Smith",
  "email": "rudolph.smith@example.com",
  "is_superadmin": true,
  "is_accountant": false
}
```

---

## `GET` `/3.0/users/me` — Fetch the authenticated user

operationId: `v3ShowMe`

This action fetches the user authenticated by the bearer token.

### Responses

200

**200** — OK

**Response samples** (200):

```json
{
  "id": 4,
  "salutation_type": "male",
  "firstname": "Rudolph",
  "lastname": "Smith",
  "email": "rudolph.smith@example.com",
  "is_superadmin": true,
  "is_accountant": false
}
```

---

## `GET` `/3.0/fictional_users` — Fetch a list of fictional users

operationId: `v3ListFictionalUsers`

This action fetches a list of all fictional users. These fictional users can be used in dropdowns but can not log in to the application

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
    "id": 4,
    "salutation_type": "male",
    "firstname": "Rudolph",
    "lastname": "Smith",
    "email": "rudolph.smith@bexio.com",
    "title_id": null
  }
]
```

---

## `POST` `/3.0/fictional_users` — Create a fictional user

operationId: `v3CreateFictionalUser`

This action creates a new fictional user

### Request Body schema: application/json *(required)*

| Parameter | Type | Description |
|---|---|---|
| salutation_type *(required)* | string Enum: male female |  |
| firstname *(required)* | string | The first name of the fictional user |
| lastname *(required)* | string | The last name of the fictional user |
| email *(required)* | string | The email address of the fictional user. Please note that an email address can only be used once for both regular and fictional users. |
| title_id | integer | A reference to a title |

### Responses

201, 422

**201** — Created

**Response samples** (201):

```json
{
  "id": 4,
  "salutation_type": "male",
  "firstname": "Rudolph",
  "lastname": "Smith",
  "email": "rudolph.smith@bexio.com",
  "title_id": null
}
```

**422** — Validation error

**Request sample**:

```json
{
  "salutation_type": "male",
  "firstname": "Rudolph",
  "lastname": "Smith",
  "email": "rudolph.smith@bexio.com",
  "title_id": null
}
```

---

## `GET` `/3.0/fictional_users/{fictional_user_id}` — Fetch a fictional User

operationId: `v3ShowFictionalUser`

This action fetches a single fictional user

### path Parameters

| Parameter | Type | Description |
|---|---|---|
| fictional_user_id *(required)* | integer <int32> | the id of the fictional user |

### Responses

200

**200** — OK

**Response samples** (200):

```json
{
  "id": 4,
  "salutation_type": "male",
  "firstname": "Rudolph",
  "lastname": "Smith",
  "email": "rudolph.smith@bexio.com",
  "title_id": null
}
```

---

## `DELETE` `/3.0/fictional_users/{fictional_user_id}` — Delete a fictional user

operationId: `v3DeleteFictionalUser`

This action permanently deletes a fictional user. It cannot be undone.

### path Parameters

| Parameter | Type | Description |
|---|---|---|
| fictional_user_id *(required)* | integer <int32> | the id of the fictional user |

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

## `PATCH` `/3.0/fictional_users/{fictional_user_id}` — Update a fictional User

operationId: `v3UpdateFictionalUser`

This action updates an existing fictional user

### path Parameters

| Parameter | Type | Description |
|---|---|---|
| fictional_user_id *(required)* | integer <int32> | the id of the fictional user |

### Request Body schema: application/json *(required)*

| Parameter | Type | Description |
|---|---|---|
| salutation_type *(required)* | string Enum: male female |  |
| firstname *(required)* | string | The first name of the fictional user |
| lastname *(required)* | string | The last name of the fictional user |
| email *(required)* | string | The email address of the fictional user. Please note that an email address can only be used once for both regular and fictional users. |
| title_id | integer | A reference to a title |

### Responses

200, 422

**200** — Ok

**Response samples** (200):

```json
{
  "id": 4,
  "salutation_type": "male",
  "firstname": "Rudolph",
  "lastname": "Smith",
  "email": "rudolph.smith@bexio.com",
  "title_id": null
}
```

**422** — Validation error

**Request sample**:

```json
{
  "salutation_type": "male",
  "firstname": "Rudolph",
  "lastname": "Smith",
  "email": "rudolph.smith@bexio.com",
  "title_id": null
}
```

---
