# Projects

Part of **Projects & Time Tracking**. Extracted from docs.bexio.com (snapshot Mon, 28 Sep 2026 12:05:15 GMT). 20 operations.

| Method | Path | Title |
|---|---|---|
| `GET` | `/2.0/pr_project` | Fetch a list of projects |
| `POST` | `/2.0/pr_project` | Create project |
| `POST` | `/2.0/pr_project/search` | Search projects |
| `GET` | `/2.0/pr_project/{project_id}` | Fetch a project |
| `POST` | `/2.0/pr_project/{project_id}` | Edit a project |
| `DELETE` | `/2.0/pr_project/{project_id}` | Delete a project |
| `POST` | `/2.0/pr_project/{project_id}/archive` | Archive a project |
| `POST` | `/2.0/pr_project/{project_id}/reactivate` | Unarchive a project |
| `GET` | `/2.0/pr_project_state` | Project status |
| `GET` | `/2.0/pr_project_type` | Project types |
| `GET` | `/3.0/projects/{project_id}/milestones` | Fetch a list of milestones |
| `POST` | `/3.0/projects/{project_id}/milestones` | Create milestone |
| `GET` | `/3.0/projects/{project_id}/milestones/{milestone_id}` | Fetch a milestone |
| `POST` | `/3.0/projects/{project_id}/milestones/{milestone_id}` | Edit a milestone |
| `DELETE` | `/3.0/projects/{project_id}/milestones/{milestone_id}` | Delete a milestone |
| `GET` | `/3.0/projects/{project_id}/packages` | Fetch a list of work packages |
| `POST` | `/3.0/projects/{project_id}/packages` | Create work package |
| `GET` | `/3.0/projects/{project_id}/packages/{package_id}` | Fetch a work package |
| `DELETE` | `/3.0/projects/{project_id}/packages/{package_id}` | Delete a work package |
| `PATCH` | `/3.0/projects/{project_id}/packages/{package_id}` | Edit a work package |

## `GET` `/2.0/pr_project` — Fetch a list of projects

operationId: `v2ListProjects`

This action fetches a list of all projects

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
    "id": 2,
    "uuid": "046b6c7f-0b8a-43b9-b35d-6489e6daee91",
    "nr": "000002",
    "name": "Villa Kunterbunt",
    "start_date": "2019-07-12 00:00:00",
    "end_date": null,
    "comment": "",
    "pr_state_id": 2,
    "pr_project_type_id": 2,
    "contact_id": 2,
    "contact_sub_id": null,
    "pr_invoice_type_id": 3,
    "pr_invoice_type_amount": "230.00",
    "pr_budget_type_id": 1,
    "pr_budget_type_amount": "200.00",
    "user_id": 1
  }
]
```

---

## `POST` `/2.0/pr_project` — Create project

operationId: `v2CreateProject`

This action creates a new project

### Request Body schema: application/json *(required)*

| Parameter | Type | Description |
|---|---|---|
| document_nr | string | Can not be used if “automatic numbering” is activated in frontend-settings. Required if “automatic numbering” deactivated. https://help.bexio.com/s/article/000001721 |
| name *(required)* | string |  |
| start_date | string <date-time> or null |  |
| end_date | string <date-time> or null |  |
| comment | string |  |
| pr_state_id *(required)* | integer | References a project status object |
| pr_project_type_id *(required)* | integer | References a project type object |
| contact_id *(required)* | integer | References a contact object |
| contact_sub_id | integer or null | References a contact object |
| pr_invoice_type_id | integer or null | The following invoice types are available: Id Name Description 1 type_hourly_rate_service Hourly rate for client services 2 type_hourly_rate_employee Hourly rate for employee 3 type_hourly_rate_project Hourly rate for project 4 type_fix Fix price for project |
| pr_invoice_type_amount | string | This field can only be edited if the `pr_invoice_type` is set. (Only supported for invoice types: `type_hourly_rate_project` and `type_fix`) |
| pr_budget_type_id | number or null | The following budget types are available: Id Name Description 1 type_budgeted_costs Total budget costs 2 type_budgeted_hours Total budget hours 3 type_service_budget Budget for each client services 4 type_service_employees Budget for each employee |
| pr_budget_type_amount | string | This field can only be edited if the `pr_budget_type` is set. (Only supported for budget types: `type_budgeted_costs` and `type_budgeted_hours`) |
| user_id *(required)* | integer | References a user object |

### Responses

201, 422

**201** — Created

**Response samples** (201):

```json
{
  "id": 2,
  "uuid": "046b6c7f-0b8a-43b9-b35d-6489e6daee91",
  "nr": "000002",
  "name": "Villa Kunterbunt",
  "start_date": "2019-07-12 00:00:00",
  "end_date": null,
  "comment": "",
  "pr_state_id": 2,
  "pr_project_type_id": 2,
  "contact_id": 2,
  "contact_sub_id": null,
  "pr_invoice_type_id": 3,
  "pr_invoice_type_amount": "230.00",
  "pr_budget_type_id": 1,
  "pr_budget_type_amount": "200.00",
  "user_id": 1
}
```

**422** — Validation error

**Request sample**:

```json
{
  "document_nr": "project name",
  "name": "Villa Kunterbunt",
  "start_date": "2019-07-12 00:00:00",
  "end_date": null,
  "comment": "",
  "pr_state_id": 2,
  "pr_project_type_id": 2,
  "contact_id": 2,
  "contact_sub_id": null,
  "pr_invoice_type_id": 3,
  "pr_invoice_type_amount": "230.00",
  "pr_budget_type_id": 1,
  "pr_budget_type_amount": "200.00",
  "user_id": 1
}
```

---

## `POST` `/2.0/pr_project/search` — Search projects

operationId: `v2SearchProjects`

Search projects via query. Please refer to the Search section for detailed instructions.
The following search fields are supported:
- `name`
- `contact_id`
- `pr_state_id`

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
    "id": 2,
    "uuid": "046b6c7f-0b8a-43b9-b35d-6489e6daee91",
    "nr": "000002",
    "name": "Villa Kunterbunt",
    "start_date": "2019-07-12 00:00:00",
    "end_date": null,
    "comment": "",
    "pr_state_id": 2,
    "pr_project_type_id": 2,
    "contact_id": 2,
    "contact_sub_id": null,
    "pr_invoice_type_id": 3,
    "pr_invoice_type_amount": "230.00",
    "pr_budget_type_id": 1,
    "pr_budget_type_amount": "200.00",
    "user_id": 1
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

## `GET` `/2.0/pr_project/{project_id}` — Fetch a project

operationId: `v2ShowProject`

This action fetches a single project

### path Parameters

| Parameter | Type | Description |
|---|---|---|
| project_id *(required)* | integer <int32> | the id of the project |

### Responses

200

**200** — OK

**Response samples** (200):

```json
{
  "id": 2,
  "uuid": "046b6c7f-0b8a-43b9-b35d-6489e6daee91",
  "nr": "000002",
  "name": "Villa Kunterbunt",
  "start_date": "2019-07-12 00:00:00",
  "end_date": null,
  "comment": "",
  "pr_state_id": 2,
  "pr_project_type_id": 2,
  "contact_id": 2,
  "contact_sub_id": null,
  "pr_invoice_type_id": 3,
  "pr_invoice_type_amount": "230.00",
  "pr_budget_type_id": 1,
  "pr_budget_type_amount": "200.00",
  "user_id": 1
}
```

---

## `POST` `/2.0/pr_project/{project_id}` — Edit a project

operationId: `v2EditProject`

This action edits a single project

### path Parameters

| Parameter | Type | Description |
|---|---|---|
| project_id *(required)* | integer <int32> | the id of the project |

### Request Body schema: application/json

| Parameter | Type | Description |
|---|---|---|
| document_nr | string | Can not be used if “automatic numbering” is activated in frontend-settings. Required if “automatic numbering” deactivated. https://help.bexio.com/s/article/000001721 |
| name *(required)* | string |  |
| start_date | string <date-time> or null |  |
| end_date | string <date-time> or null |  |
| comment | string |  |
| pr_state_id *(required)* | integer | References a project status object |
| pr_project_type_id *(required)* | integer | References a project type object |
| contact_id *(required)* | integer | References a contact object |
| contact_sub_id | integer or null | References a contact object |
| pr_invoice_type_id | integer or null | The following invoice types are available: Id Name Description 1 type_hourly_rate_service Hourly rate for client services 2 type_hourly_rate_employee Hourly rate for employee 3 type_hourly_rate_project Hourly rate for project 4 type_fix Fix price for project |
| pr_invoice_type_amount | string | This field can only be edited if the `pr_invoice_type` is set. (Only supported for invoice types: `type_hourly_rate_project` and `type_fix`) |
| pr_budget_type_id | number or null | The following budget types are available: Id Name Description 1 type_budgeted_costs Total budget costs 2 type_budgeted_hours Total budget hours 3 type_service_budget Budget for each client services 4 type_service_employees Budget for each employee |
| pr_budget_type_amount | string | This field can only be edited if the `pr_budget_type` is set. (Only supported for budget types: `type_budgeted_costs` and `type_budgeted_hours`) |
| user_id *(required)* | integer | References a user object |

### Responses

200, 422

**200** — OK

**Response samples** (200):

```json
{
  "id": 2,
  "uuid": "046b6c7f-0b8a-43b9-b35d-6489e6daee91",
  "nr": "000002",
  "name": "Villa Kunterbunt",
  "start_date": "2019-07-12 00:00:00",
  "end_date": null,
  "comment": "",
  "pr_state_id": 2,
  "pr_project_type_id": 2,
  "contact_id": 2,
  "contact_sub_id": null,
  "pr_invoice_type_id": 3,
  "pr_invoice_type_amount": "230.00",
  "pr_budget_type_id": 1,
  "pr_budget_type_amount": "200.00",
  "user_id": 1
}
```

**422** — Validation error

**Request sample**:

```json
{
  "document_nr": "project name",
  "name": "Villa Kunterbunt",
  "start_date": "2019-07-12 00:00:00",
  "end_date": null,
  "comment": "",
  "pr_state_id": 2,
  "pr_project_type_id": 2,
  "contact_id": 2,
  "contact_sub_id": null,
  "pr_invoice_type_id": 3,
  "pr_invoice_type_amount": "230.00",
  "pr_budget_type_id": 1,
  "pr_budget_type_amount": "200.00",
  "user_id": 1
}
```

---

## `DELETE` `/2.0/pr_project/{project_id}` — Delete a project

operationId: `DeleteProject`

This action permanently deletes a project. It cannot be undone.

### path Parameters

| Parameter | Type | Description |
|---|---|---|
| project_id *(required)* | integer <int32> | the id of the project |

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

## `POST` `/2.0/pr_project/{project_id}/archive` — Archive a project

operationId: `v2ArchiveProject`

This action archives a project

### path Parameters

| Parameter | Type | Description |
|---|---|---|
| project_id *(required)* | integer <int32> | the id of the project |

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

## `POST` `/2.0/pr_project/{project_id}/reactivate` — Unarchive a project

operationId: `v2UnarchiveProject`

This action unarchives an archived project

### path Parameters

| Parameter | Type | Description |
|---|---|---|
| project_id *(required)* | integer <int32> | the id of the project |

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

## `GET` `/2.0/pr_project_state` — Project status

operationId: `v2ListProjectStatus`

This action fetches a list of project status

### Responses

200

**200** — OK

**Response samples** (200):

```json
[
  {
    "id": 1,
    "name": "Active"
  }
]
```

---

## `GET` `/2.0/pr_project_type` — Project types

operationId: `v2ListProjectType`

This action fetches a list of project types

### query Parameters

| Parameter | Type | Description |
|---|---|---|
| order_by | string Default: id Enum: id name | Defines the order of the results. Multiple sort parameters can be combined by using a comma separator. `_asc` and `_desc` can be appended to any parameter to either sort ascending (default) or descending. |

### Responses

200

**200** — OK

**Response samples** (200):

```json
[
  {
    "id": 1,
    "name": "Internal Project"
  }
]
```

---

## `GET` `/3.0/projects/{project_id}/milestones` — Fetch a list of milestones

operationId: `ListMilestones`

This action fetches a list of all milestones for a given project

### path Parameters

| Parameter | Type | Description |
|---|---|---|
| project_id *(required)* | integer <int32> | the id of the project |

### query Parameters

| Parameter | Type | Description |
|---|---|---|
| limit | integer <int32> Default: 500 | Limit the number of results (max is 2000) |
| offset | integer <int32> Default: 0 | Skip over a number of elements by specifying an offset value for the query |

### Responses

200, 422

**200** — OK

**Response samples** (200):

```json
[
  {
    "id": 4,
    "name": "project documentation",
    "end_date": "2018-05-18",
    "comment": "Finish project documentation.",
    "pr_parent_milestone_id": 3
  }
]
```

**422** — Validation error

---

## `POST` `/3.0/projects/{project_id}/milestones` — Create milestone

operationId: `CreateMilestone`

This action creates a new milestone

### path Parameters

| Parameter | Type | Description |
|---|---|---|
| project_id *(required)* | integer <int32> | the id of the project |

### Request Body schema: application/json *(required)*

| Parameter | Type | Description |
|---|---|---|
| name *(required)* | string | The name of the milestone |
| end_date | string <date> | The end date for the milestone |
| comment | string | Description for milestone |
| pr_parent_milestone_id | integer <int32> | Higher level milestone |

### Responses

201, 422

**201** — Created

**Response samples** (201):

```json
{
  "id": 4,
  "name": "project documentation",
  "end_date": "2018-05-18",
  "comment": "Finish project documentation.",
  "pr_parent_milestone_id": 3
}
```

**422** — Validation error

**Request sample**:

```json
{
  "name": "project documentation",
  "end_date": "2018-05-18",
  "comment": "Finish project documentation.",
  "pr_parent_milestone_id": 3
}
```

---

## `GET` `/3.0/projects/{project_id}/milestones/{milestone_id}` — Fetch a milestone

operationId: `ShowMilestone`

This action fetches a single milestone

### path Parameters

| Parameter | Type | Description |
|---|---|---|
| project_id *(required)* | integer <int32> | the id of the project |
| milestone_id *(required)* | integer <int32> | the id of the milestone |

### Responses

200

**200** — OK

**Response samples** (200):

```json
{
  "id": 4,
  "name": "project documentation",
  "end_date": "2018-05-18",
  "comment": "Finish project documentation.",
  "pr_parent_milestone_id": 3
}
```

---

## `POST` `/3.0/projects/{project_id}/milestones/{milestone_id}` — Edit a milestone

operationId: `EditMilestone`

This action edits a single milestone

### path Parameters

| Parameter | Type | Description |
|---|---|---|
| project_id *(required)* | integer <int32> | the id of the project |
| milestone_id *(required)* | integer <int32> | the id of the milestone |

### Request Body schema: application/json

| Parameter | Type | Description |
|---|---|---|
| name *(required)* | string | The name of the milestone |
| end_date | string <date> | The end date for the milestone |
| comment | string | Description for milestone |
| pr_parent_milestone_id | integer <int32> | Higher level milestone |

### Responses

200, 422

**200** — OK

**Response samples** (200):

```json
{
  "id": 4,
  "name": "project documentation",
  "end_date": "2018-05-18",
  "comment": "Finish project documentation.",
  "pr_parent_milestone_id": 3
}
```

**422** — Validation error

**Request sample**:

```json
{
  "name": "project documentation",
  "end_date": "2018-05-18",
  "comment": "Finish project documentation.",
  "pr_parent_milestone_id": 3
}
```

---

## `DELETE` `/3.0/projects/{project_id}/milestones/{milestone_id}` — Delete a milestone

operationId: `DeleteMilestone`

This action permanently deletes a milestone. It cannot be undone.

### path Parameters

| Parameter | Type | Description |
|---|---|---|
| project_id *(required)* | integer <int32> | the id of the project |
| milestone_id *(required)* | integer <int32> | the id of the milestone |

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

## `GET` `/3.0/projects/{project_id}/packages` — Fetch a list of work packages

operationId: `ListWorkPackages`

This action fetches a list of all work packages for a given project

### path Parameters

| Parameter | Type | Description |
|---|---|---|
| project_id *(required)* | integer <int32> | the id of the project |

### query Parameters

| Parameter | Type | Description |
|---|---|---|
| limit | integer <int32> Default: 500 | Limit the number of results (max is 2000) |
| offset | integer <int32> Default: 0 | Skip over a number of elements by specifying an offset value for the query |

### Responses

200, 422

**200** — OK

**Response samples** (200):

```json
[
  {
    "id": 4,
    "name": "Documentation",
    "spent_time_in_hours": 0.5,
    "estimated_time_in_hours": 1.75,
    "comment": "Crete project documentation",
    "pr_milestone_id": 3
  }
]
```

**422** — Validation error

---

## `POST` `/3.0/projects/{project_id}/packages` — Create work package

operationId: `CreateWorkPackage`

This action creates a new work package

### path Parameters

| Parameter | Type | Description |
|---|---|---|
| project_id *(required)* | integer <int32> | the id of the project |

### Request Body schema: application/json *(required)*

| Parameter | Type | Description |
|---|---|---|
| name *(required)* | string | The name of the work package |
| spent_time_in_hours | number | time spent on work package |
| estimated_time_in_hours | number | estimated time on work package |
| comment | string | Description for work package |
| pr_milestone_id | integer <int32> | References a milestone object |

### Responses

201, 422

**201** — Created

**Response samples** (201):

```json
{
  "id": 4,
  "name": "Documentation",
  "spent_time_in_hours": 0.5,
  "estimated_time_in_hours": 1.75,
  "comment": "Crete project documentation",
  "pr_milestone_id": 3
}
```

**422** — Validation error

**Request sample**:

```json
{
  "name": "Documentation",
  "spent_time_in_hours": 0.5,
  "estimated_time_in_hours": 1.75,
  "comment": "Crete project documentation",
  "pr_milestone_id": 3
}
```

---

## `GET` `/3.0/projects/{project_id}/packages/{package_id}` — Fetch a work package

operationId: `ShowWorkPackage`

This action fetches a single work package

### path Parameters

| Parameter | Type | Description |
|---|---|---|
| project_id *(required)* | integer <int32> | the id of the project |
| package_id *(required)* | integer <int32> | the id of the work package |

### Responses

200

**200** — OK

**Response samples** (200):

```json
{
  "id": 4,
  "name": "Documentation",
  "spent_time_in_hours": 0.5,
  "estimated_time_in_hours": 1.75,
  "comment": "Crete project documentation",
  "pr_milestone_id": 3
}
```

---

## `DELETE` `/3.0/projects/{project_id}/packages/{package_id}` — Delete a work package

operationId: `DeleteWorkPackage`

This action permanently deletes a work package. It cannot be undone.

### path Parameters

| Parameter | Type | Description |
|---|---|---|
| project_id *(required)* | integer <int32> | the id of the project |
| package_id *(required)* | integer <int32> | the id of the work package |

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

## `PATCH` `/3.0/projects/{project_id}/packages/{package_id}` — Edit a work package

operationId: `EditWorkPackage`

This action edits a single work package

### path Parameters

| Parameter | Type | Description |
|---|---|---|
| project_id *(required)* | integer <int32> | the id of the project |
| package_id *(required)* | integer <int32> | the id of the work package |

### Request Body schema: application/json

| Parameter | Type | Description |
|---|---|---|
| name *(required)* | string | The name of the work package |
| spent_time_in_hours | number | time spent on work package |
| estimated_time_in_hours | number | estimated time on work package |
| comment | string | Description for work package |
| pr_milestone_id | integer <int32> | References a milestone object |

### Responses

200, 422

**200** — OK

**Response samples** (200):

```json
{
  "id": 4,
  "name": "Documentation",
  "spent_time_in_hours": 0.5,
  "estimated_time_in_hours": 1.75,
  "comment": "Crete project documentation",
  "pr_milestone_id": 3
}
```

**422** — Validation error

**Request sample**:

```json
{
  "name": "Documentation",
  "spent_time_in_hours": 0.5,
  "estimated_time_in_hours": 1.75,
  "comment": "Crete project documentation",
  "pr_milestone_id": 3
}
```

---
