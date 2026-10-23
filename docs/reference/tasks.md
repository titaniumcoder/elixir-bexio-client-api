# Tasks

Part of **Other endpoints**. Extracted from docs.bexio.com (snapshot Mon, 28 Sep 2026 12:05:15 GMT). 8 operations.

| Method | Path | Title |
|---|---|---|
| `GET` | `/2.0/task` | Fetch a list of tasks |
| `POST` | `/2.0/task` | Create task |
| `POST` | `/2.0/task/search` | Search tasks |
| `GET` | `/2.0/task/{task_id}` | Fetch a task |
| `POST` | `/2.0/task/{task_id}` | Edit a task |
| `DELETE` | `/2.0/task/{task_id}` | Delete a task |
| `GET` | `/2.0/todo_priority` | Task priorities |
| `GET` | `/2.0/todo_status` | Task status |

## `GET` `/2.0/task` — Fetch a list of tasks

operationId: `v2ListTasks`

This action fetches a list of all tasks

### query Parameters

| Parameter | Type | Description |
|---|---|---|
| order_by | string Default: id Enum: id finish_date | Defines the order of the results. Multiple sort parameters can be combined by using a comma separator. `_asc` and `_desc` can be appended to any parameter to either sort ascending (default) or descending. |
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
    "user_id": 1,
    "finish_date": "2018-04-09T07:44:10+00:00",
    "subject": "Unterlagen versenden",
    "place": 0,
    "info": "so schnell wie m\u00f6glich.",
    "contact_id": 1,
    "sub_contact_id": null,
    "project_id": null,
    "entry_id": null,
    "module_id": null,
    "todo_status_id": 1,
    "todo_priority_id": null,
    "has_reminder": false,
    "remember_type_id": null,
    "remember_time_id": null,
    "communication_kind_id": null
  }
]
```

---

## `POST` `/2.0/task` — Create task

operationId: `v2CreateTask`

This action creates a new task

### Request Body schema: application/json *(required)*

| Parameter | Type | Description |
|---|---|---|
| user_id *(required)* | integer <int32> | References a user object |
| finish_date | string <date-time> or null |  |
| subject *(required)* | string |  |
| info | string |  |
| contact_id | integer <int32> | References a contact object |
| sub_contact_id | integer or null | References a contact object |
| pr_project_id | integer or null | References a project object |
| entry_id | integer or null |  |
| module_id | integer or null |  |
| todo_status_id | integer <int32> |  |
| todo_priority_id | integer or null |  |
| have_remember | boolean |  |
| remember_type_id | integer | Is required if `have_remember` is set to true. |
| remember_time_id | integer or null | Is required if `have_remember` is set to true. |
| communication_kind_id | integer or null |  |

### Responses

201, 422

**201** — Created

**Response samples** (201):

```json
{
  "id": 1,
  "user_id": 1,
  "finish_date": "2018-04-09T07:44:10+00:00",
  "subject": "Unterlagen versenden",
  "place": 0,
  "info": "so schnell wie m\u00f6glich.",
  "contact_id": 1,
  "sub_contact_id": null,
  "project_id": null,
  "entry_id": null,
  "module_id": null,
  "todo_status_id": 1,
  "todo_priority_id": null,
  "has_reminder": false,
  "remember_type_id": null,
  "remember_time_id": null,
  "communication_kind_id": null
}
```

**422** — Validation error

**Request sample**:

```json
{
  "user_id": 1,
  "finish_date": "2018-04-09T07:44:10+00:00",
  "subject": "Unterlagen versenden",
  "info": "so schnell wie m\u00f6glich.",
  "contact_id": 1,
  "sub_contact_id": null,
  "pr_project_id": null,
  "entry_id": null,
  "module_id": null,
  "todo_status_id": 1,
  "todo_priority_id": null,
  "have_remember": false,
  "remember_type_id": null,
  "remember_time_id": null,
  "communication_kind_id": null
}
```

---

## `POST` `/2.0/task/search` — Search tasks

operationId: `v2SearchTasks`

Search tasks via query. Please refer to the Search section for detailed instructions.
The following search fields are supported:
- `subject`
- `updated_at`
- `user_id`
- `contact_id`
- `todo_status_id`
- `module_id`
- `entry_id`

### query Parameters

| Parameter | Type | Description |
|---|---|---|
| order_by | string Default: id Enum: id finish_date | Defines the order of the results. Multiple sort parameters can be combined by using a comma separator. `_asc` and `_desc` can be appended to any parameter to either sort ascending (default) or descending. |
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
    "user_id": 1,
    "finish_date": "2018-04-09T07:44:10+00:00",
    "subject": "Unterlagen versenden",
    "place": 0,
    "info": "so schnell wie m\u00f6glich.",
    "contact_id": 1,
    "sub_contact_id": null,
    "project_id": null,
    "entry_id": null,
    "module_id": null,
    "todo_status_id": 1,
    "todo_priority_id": null,
    "has_reminder": false,
    "remember_type_id": null,
    "remember_time_id": null,
    "communication_kind_id": null
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

## `GET` `/2.0/task/{task_id}` — Fetch a task

operationId: `v2ShowTask`

This action fetches a single task

### path Parameters

| Parameter | Type | Description |
|---|---|---|
| task_id *(required)* | integer <int32> | the id of the task |

### Responses

200

**200** — OK

**Response samples** (200):

```json
{
  "id": 1,
  "user_id": 1,
  "finish_date": "2018-04-09T07:44:10+00:00",
  "subject": "Unterlagen versenden",
  "place": 0,
  "info": "so schnell wie m\u00f6glich.",
  "contact_id": 1,
  "sub_contact_id": null,
  "project_id": null,
  "entry_id": null,
  "module_id": null,
  "todo_status_id": 1,
  "todo_priority_id": null,
  "has_reminder": false,
  "remember_type_id": null,
  "remember_time_id": null,
  "communication_kind_id": null
}
```

---

## `POST` `/2.0/task/{task_id}` — Edit a task

operationId: `v2EditTask`

This action edits a single task

### path Parameters

| Parameter | Type | Description |
|---|---|---|
| task_id *(required)* | integer <int32> | the id of the task |

### Request Body schema: application/json

| Parameter | Type | Description |
|---|---|---|
| user_id *(required)* | integer <int32> | References a user object |
| finish_date | string <date-time> or null |  |
| subject *(required)* | string |  |
| info | string |  |
| contact_id | integer <int32> | References a contact object |
| sub_contact_id | integer or null | References a contact object |
| pr_project_id | integer or null | References a project object |
| entry_id | integer or null |  |
| module_id | integer or null |  |
| todo_status_id | integer <int32> |  |
| todo_priority_id | integer or null |  |
| have_remember | boolean |  |
| remember_type_id | integer | Is required if `have_remember` is set to true. |
| remember_time_id | integer or null | Is required if `have_remember` is set to true. |
| communication_kind_id | integer or null |  |

### Responses

200, 422

**200** — OK

**Response samples** (200):

```json
{
  "id": 1,
  "user_id": 1,
  "finish_date": "2018-04-09T07:44:10+00:00",
  "subject": "Unterlagen versenden",
  "place": 0,
  "info": "so schnell wie m\u00f6glich.",
  "contact_id": 1,
  "sub_contact_id": null,
  "project_id": null,
  "entry_id": null,
  "module_id": null,
  "todo_status_id": 1,
  "todo_priority_id": null,
  "has_reminder": false,
  "remember_type_id": null,
  "remember_time_id": null,
  "communication_kind_id": null
}
```

**422** — Validation error

**Request sample**:

```json
{
  "user_id": 1,
  "finish_date": "2018-04-09T07:44:10+00:00",
  "subject": "Unterlagen versenden",
  "info": "so schnell wie m\u00f6glich.",
  "contact_id": 1,
  "sub_contact_id": null,
  "pr_project_id": null,
  "entry_id": null,
  "module_id": null,
  "todo_status_id": 1,
  "todo_priority_id": null,
  "have_remember": false,
  "remember_type_id": null,
  "remember_time_id": null,
  "communication_kind_id": null
}
```

---

## `DELETE` `/2.0/task/{task_id}` — Delete a task

operationId: `DeleteTask`

This action permanently deletes a task. It cannot be undone.

### path Parameters

| Parameter | Type | Description |
|---|---|---|
| task_id *(required)* | integer <int32> | the id of the task |

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

## `GET` `/2.0/todo_priority` — Task priorities

operationId: `v2ListTaskPriorities`

This action fetches a list of all task priorities

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
    "name": "High"
  }
]
```

---

## `GET` `/2.0/todo_status` — Task status

operationId: `v2ListTaskStatus`

This action fetches a list of all task status

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
    "name": "Open"
  }
]
```

---
