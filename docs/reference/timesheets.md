# Timesheets

Part of **Projects & Time Tracking**. Extracted from docs.bexio.com (snapshot Mon, 28 Sep 2026 12:05:15 GMT). 7 operations.

| Method | Path | Title |
|---|---|---|
| `GET` | `/2.0/timesheet` | Fetch a list of timesheets |
| `POST` | `/2.0/timesheet` | Create timesheet |
| `POST` | `/2.0/timesheet/search` | Search timesheets |
| `GET` | `/2.0/timesheet/{timesheet_id}` | Fetch a timesheet |
| `POST` | `/2.0/timesheet/{timesheet_id}` | Edit a timesheet |
| `DELETE` | `/2.0/timesheet/{timesheet_id}` | Delete a timesheet |
| `GET` | `/2.0/timesheet_status` | Timesheet status |

## `GET` `/2.0/timesheet` — Fetch a list of timesheets

operationId: `v2ListTimesheets`

This action fetches a list of all timesheets

### query Parameters

| Parameter | Type | Description |
|---|---|---|
| order_by | string Default: id Enum: id date | Defines the order of the results. Multiple sort parameters can be combined by using a comma separator. `_asc` and `_desc` can be appended to any parameter to either sort ascending (default) or descending. |
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
    "user_id": 1,
    "status_id": 4,
    "client_service_id": 1,
    "text": "",
    "allowable_bill": true,
    "charge": null,
    "contact_id": 2,
    "sub_contact_id": null,
    "pr_project_id": null,
    "pr_package_id": null,
    "pr_milestone_id": null,
    "travel_time": null,
    "travel_charge": null,
    "travel_distance": 0,
    "estimated_time": "02:30",
    "date": "2019-05-20",
    "duration": "01:40",
    "running": false,
    "tracking": {
      "type": "duration",
      "date": "2019-05-20",
      "duration": "01:40"
    }
  }
]
```

---

## `POST` `/2.0/timesheet` — Create timesheet

operationId: `v2CreateTimesheet`

This action creates a new timesheet

### Request Body schema: application/json *(required)*

| Parameter | Type | Description |
|---|---|---|
| user_id *(required)* | integer | References a user object |
| status_id | integer | References a timesheet status object |
| client_service_id *(required)* | integer | References a business activity object |
| text | string |  |
| allowable_bill *(required)* | boolean |  |
| charge | string or null |  |
| contact_id | integer or null | References a contact object |
| sub_contact_id | integer or null | References a contact object |
| pr_project_id | integer or null | References a project object |
| pr_package_id | integer or null |  |
| pr_milestone_id | integer or null |  |
| estimated_time | string or null |  |
| tracking *(required)* | object | Two different formats can be used to submit the tracked time. Either type `range` or type `duration`. |

### Responses

201, 422

**201** — Created

**Response samples** (201):

```json
{
  "id": 2,
  "user_id": 1,
  "status_id": 4,
  "client_service_id": 1,
  "text": "",
  "allowable_bill": true,
  "charge": null,
  "contact_id": 2,
  "sub_contact_id": null,
  "pr_project_id": null,
  "pr_package_id": null,
  "pr_milestone_id": null,
  "travel_time": null,
  "travel_charge": null,
  "travel_distance": 0,
  "estimated_time": "02:30",
  "date": "2019-05-20",
  "duration": "01:40",
  "running": false,
  "tracking": {
    "type": "duration",
    "date": "2019-05-20",
    "duration": "01:40"
  }
}
```

**422** — Validation error

**Request sample**:

```json
{
  "user_id": 1,
  "status_id": 4,
  "client_service_id": 1,
  "text": "",
  "allowable_bill": true,
  "charge": null,
  "contact_id": 2,
  "sub_contact_id": null,
  "pr_project_id": null,
  "pr_package_id": null,
  "pr_milestone_id": null,
  "estimated_time": "02:30",
  "tracking": {
    "type": "duration",
    "date": "2019-05-20",
    "duration": "01:40"
  }
}
```

---

## `POST` `/2.0/timesheet/search` — Search timesheets

operationId: `v2SearchTimesheets`

Search timesheets via query. Please refer to the Search section for detailed instructions.
The following search fields are supported:
- `id`
- `client_service_id`
- `contact_id`
- `user_id`
- `pr_project_id`
- `status_id`

### query Parameters

| Parameter | Type | Description |
|---|---|---|
| order_by | string Default: id Enum: id date | Defines the order of the results. Multiple sort parameters can be combined by using a comma separator. `_asc` and `_desc` can be appended to any parameter to either sort ascending (default) or descending. |
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
    "user_id": 1,
    "status_id": 4,
    "client_service_id": 1,
    "text": "",
    "allowable_bill": true,
    "charge": null,
    "contact_id": 2,
    "sub_contact_id": null,
    "pr_project_id": null,
    "pr_package_id": null,
    "pr_milestone_id": null,
    "travel_time": null,
    "travel_charge": null,
    "travel_distance": 0,
    "estimated_time": "02:30",
    "date": "2019-05-20",
    "duration": "01:40",
    "running": false,
    "tracking": {
      "type": "duration",
      "date": "2019-05-20",
      "duration": "01:40"
    }
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

## `GET` `/2.0/timesheet/{timesheet_id}` — Fetch a timesheet

operationId: `v2ShowTimesheet`

This action fetches a single timesheet

### path Parameters

| Parameter | Type | Description |
|---|---|---|
| timesheet_id *(required)* | integer <int32> | the id of the timesheet |

### Responses

200

**200** — OK

**Response samples** (200):

```json
{
  "id": 2,
  "user_id": 1,
  "status_id": 4,
  "client_service_id": 1,
  "text": "",
  "allowable_bill": true,
  "charge": null,
  "contact_id": 2,
  "sub_contact_id": null,
  "pr_project_id": null,
  "pr_package_id": null,
  "pr_milestone_id": null,
  "travel_time": null,
  "travel_charge": null,
  "travel_distance": 0,
  "estimated_time": "02:30",
  "date": "2019-05-20",
  "duration": "01:40",
  "running": false,
  "tracking": {
    "type": "duration",
    "date": "2019-05-20",
    "duration": "01:40"
  }
}
```

---

## `POST` `/2.0/timesheet/{timesheet_id}` — Edit a timesheet

operationId: `v2EditTimesheet`

This action edits a single timesheet

### path Parameters

| Parameter | Type | Description |
|---|---|---|
| timesheet_id *(required)* | integer <int32> | the id of the timesheet |

### Request Body schema: application/json

| Parameter | Type | Description |
|---|---|---|
| user_id *(required)* | integer | References a user object |
| status_id | integer | References a timesheet status object |
| client_service_id *(required)* | integer | References a business activity object |
| text | string |  |
| allowable_bill *(required)* | boolean |  |
| charge | string or null |  |
| contact_id | integer or null | References a contact object |
| sub_contact_id | integer or null | References a contact object |
| pr_project_id | integer or null | References a project object |
| pr_package_id | integer or null |  |
| pr_milestone_id | integer or null |  |
| estimated_time | string or null |  |
| tracking *(required)* | object | Two different formats can be used to submit the tracked time. Either type `range` or type `duration`. |

### Responses

200, 422

**200** — OK

**Response samples** (200):

```json
{
  "id": 2,
  "user_id": 1,
  "status_id": 4,
  "client_service_id": 1,
  "text": "",
  "allowable_bill": true,
  "charge": null,
  "contact_id": 2,
  "sub_contact_id": null,
  "pr_project_id": null,
  "pr_package_id": null,
  "pr_milestone_id": null,
  "travel_time": null,
  "travel_charge": null,
  "travel_distance": 0,
  "estimated_time": "02:30",
  "date": "2019-05-20",
  "duration": "01:40",
  "running": false,
  "tracking": {
    "type": "duration",
    "date": "2019-05-20",
    "duration": "01:40"
  }
}
```

**422** — Validation error

**Request sample**:

```json
{
  "user_id": 1,
  "status_id": 4,
  "client_service_id": 1,
  "text": "",
  "allowable_bill": true,
  "charge": null,
  "contact_id": 2,
  "sub_contact_id": null,
  "pr_project_id": null,
  "pr_package_id": null,
  "pr_milestone_id": null,
  "estimated_time": "02:30",
  "tracking": {
    "type": "duration",
    "date": "2019-05-20",
    "duration": "01:40"
  }
}
```

---

## `DELETE` `/2.0/timesheet/{timesheet_id}` — Delete a timesheet

operationId: `DeleteTimesheet`

This action permanently deletes a timesheet. It cannot be undone.

### path Parameters

| Parameter | Type | Description |
|---|---|---|
| timesheet_id *(required)* | integer <int32> | the id of the timesheet |

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

## `GET` `/2.0/timesheet_status` — Timesheet status

operationId: `v2ListTimeSheetStatus`

This action fetches a list of all timesheet Status

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
    "name": "In Progress"
  }
]
```

---
