# Notes

Part of **Other endpoints**. Extracted from docs.bexio.com (snapshot Mon, 28 Sep 2026 12:05:15 GMT). 6 operations.

| Method | Path | Title |
|---|---|---|
| `GET` | `/2.0/note` | Fetch a list of notes |
| `POST` | `/2.0/note` | Create note |
| `POST` | `/2.0/note/search` | Search notes |
| `GET` | `/2.0/note/{note_id}` | Fetch a note |
| `POST` | `/2.0/note/{note_id}` | Edit a note |
| `DELETE` | `/2.0/note/{note_id}` | Delete a note |

## `GET` `/2.0/note` — Fetch a list of notes

operationId: `v2ListNotes`

This action fetches a list of all notes

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
    "user_id": 1,
    "event_start": "2019-01-16 14:20:00",
    "subject": "API conception",
    "info": "string",
    "contact_id": 14,
    "project_id": null,
    "entry_id": null,
    "module_id": null
  }
]
```

---

## `POST` `/2.0/note` — Create note

operationId: `v2CreateNote`

This action creates a new note

### Request Body schema: application/json *(required)*

| Parameter | Type | Description |
|---|---|---|
| user_id *(required)* | integer | References a user object |
| event_start *(required)* | string <date-time> |  |
| subject *(required)* | string |  |
| info | string |  |
| contact_id | integer or null | References a contact object |
| pr_project_id | integer or null | References a project object |
| entry_id | integer or null |  |
| module_id | integer or null |  |

### Responses

201, 422

**201** — Created

**Response samples** (201):

```json
{
  "id": 4,
  "user_id": 1,
  "event_start": "2019-01-16 14:20:00",
  "subject": "API conception",
  "info": "string",
  "contact_id": 14,
  "project_id": null,
  "entry_id": null,
  "module_id": null
}
```

**422** — Validation error

**Request sample**:

```json
{
  "user_id": 1,
  "event_start": "2019-01-16 14:20:00",
  "subject": "API conception",
  "info": "string",
  "contact_id": 14,
  "pr_project_id": null,
  "entry_id": null,
  "module_id": null
}
```

---

## `POST` `/2.0/note/search` — Search notes

operationId: `v2SearchNotes`

Search notes via query. Please refer to the Search section for detailed instructions.
The following search fields are supported:
- `event_start`
- `contact_id`
- `user_id`
- `subject`
- `module_id`
- `entry_id`

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
    "id": 4,
    "user_id": 1,
    "event_start": "2019-01-16 14:20:00",
    "subject": "API conception",
    "info": "string",
    "contact_id": 14,
    "project_id": null,
    "entry_id": null,
    "module_id": null
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

## `GET` `/2.0/note/{note_id}` — Fetch a note

operationId: `v2ShowNote`

This action fetches a single note

### path Parameters

| Parameter | Type | Description |
|---|---|---|
| note_id *(required)* | integer <int32> | the id of the note |

### Responses

200

**200** — OK

**Response samples** (200):

```json
{
  "id": 4,
  "user_id": 1,
  "event_start": "2019-01-16 14:20:00",
  "subject": "API conception",
  "info": "string",
  "contact_id": 14,
  "project_id": null,
  "entry_id": null,
  "module_id": null
}
```

---

## `POST` `/2.0/note/{note_id}` — Edit a note

operationId: `v2EditNote`

This action edits a single note

### path Parameters

| Parameter | Type | Description |
|---|---|---|
| note_id *(required)* | integer <int32> | the id of the note |

### Request Body schema: application/json

| Parameter | Type | Description |
|---|---|---|
| user_id *(required)* | integer | References a user object |
| event_start *(required)* | string <date-time> |  |
| subject *(required)* | string |  |
| info | string |  |
| contact_id | integer or null | References a contact object |
| pr_project_id | integer or null | References a project object |
| entry_id | integer or null |  |
| module_id | integer or null |  |

### Responses

200, 422

**200** — OK

**Response samples** (200):

```json
{
  "id": 4,
  "user_id": 1,
  "event_start": "2019-01-16 14:20:00",
  "subject": "API conception",
  "info": "string",
  "contact_id": 14,
  "project_id": null,
  "entry_id": null,
  "module_id": null
}
```

**422** — Validation error

**Request sample**:

```json
{
  "user_id": 1,
  "event_start": "2019-01-16 14:20:00",
  "subject": "API conception",
  "info": "string",
  "contact_id": 14,
  "pr_project_id": null,
  "entry_id": null,
  "module_id": null
}
```

---

## `DELETE` `/2.0/note/{note_id}` — Delete a note

operationId: `DeleteNote`

This action permanently deletes a note. It cannot be undone.

### path Parameters

| Parameter | Type | Description |
|---|---|---|
| note_id *(required)* | integer <int32> | the id of the note |

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
