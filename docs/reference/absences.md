# Absences

Part of **Payroll**. Extracted from docs.bexio.com (snapshot Mon, 28 Sep 2026 12:05:15 GMT). 5 operations.

| Method | Path | Title |
|---|---|---|
| `GET` | `/4.0/payroll/employees/{employeeId}/absences` | Retrieving absences of employee for given year |
| `POST` | `/4.0/payroll/employees/{employeeId}/absences` | Create absence for employee |
| `GET` | `/4.0/payroll/employees/{employeeId}/absences/{absenceId}` | Retrieving absence for employee with given absence id |
| `PUT` | `/4.0/payroll/employees/{employeeId}/absences/{absenceId}` | Updating existing absence |
| `DELETE` | `/4.0/payroll/employees/{employeeId}/absences/{absenceId}` | Deleting employee absence with given id |

## `GET` `/4.0/payroll/employees/{employeeId}/absences` — Retrieving absences of employee for given year

operationId: `getEmployeeAbsenceInYear`

Id of an employee

### path Parameters

| Parameter | Type | Description |
|---|---|---|
| employeeId *(required)* | string | Id of an employee |

### query Parameters

| Parameter | Type | Description |
|---|---|---|
| businessYear *(required)* | integer <int32> | Year of absence |

### Responses

200, 400, 404, 410

**200** — List of employee absences

**Response samples** (200):

```json
{
  "data": [
    {
      "reason": "Injury",
      "start_date": "2024-01-31",
      "end_date": "2024-01-31",
      "half_day": false,
      "continued_pay": 0,
      "disability": 0,
      "paid_hours": 0,
      "id": "497f6eca-6276-4993-bfeb-53cbbbba6f08"
    }
  ]
}
```

**400** — Malformed request (missing or invalid parameters)

**404** — Employee not found

**410** — Employee has been deleted

---

## `POST` `/4.0/payroll/employees/{employeeId}/absences` — Create absence for employee

operationId: `createAbsenceForEmployee`

Id of an employee

### path Parameters

| Parameter | Type | Description |
|---|---|---|
| employeeId *(required)* | string | Id of an employee |

### Request Body schema: application/json *(required)*

| Parameter | Type | Description |
|---|---|---|
| reason *(required)* | string | Currently supported reasons: Injury, Sickness, MaternityLeave, MilitaryLeave, Vacation, InterruptionOfWork. New reasons might be added in the future. |
| start_date *(required)* | string <date> |  |
| end_date | string <date> |  |
| half_day | boolean Default: False |  |
| continued_pay | number |  |
| disability | number |  |
| paid_hours | number |  |

### Responses

201, 400, 404, 410

**201** — Absence created

**Response samples** (201):

```json
{
  "reason": "Injury",
  "start_date": "2024-01-31",
  "end_date": "2024-01-31",
  "half_day": false,
  "continued_pay": 0,
  "disability": 0,
  "paid_hours": 0,
  "id": "497f6eca-6276-4993-bfeb-53cbbbba6f08"
}
```

**400** — Malformed content (missing or invalid parameters)

**404** — Employee not found

**410** — Employee has been deleted

**Request sample**:

```json
{
  "reason": "Injury",
  "start_date": "2024-01-31",
  "end_date": "2024-01-31",
  "half_day": false,
  "continued_pay": 0,
  "disability": 0,
  "paid_hours": 0
}
```

---

## `GET` `/4.0/payroll/employees/{employeeId}/absences/{absenceId}` — Retrieving absence for employee with given absence id

operationId: `getAbsence`

Id of an employee

### path Parameters

| Parameter | Type | Description |
|---|---|---|
| employeeId *(required)* | string | Id of an employee |
| absenceId *(required)* | string | Id of an absence |

### Responses

200, 400, 404, 410

**200** — Found absence

**Response samples** (200):

```json
{
  "reason": "Injury",
  "start_date": "2024-01-31",
  "end_date": "2024-01-31",
  "half_day": false,
  "continued_pay": 0,
  "disability": 0,
  "paid_hours": 0,
  "id": "497f6eca-6276-4993-bfeb-53cbbbba6f08"
}
```

**400** — Malformed request (missing or invalid parameters)

**404** — Employee or absence not found

**410** — Employee has been deleted

---

## `PUT` `/4.0/payroll/employees/{employeeId}/absences/{absenceId}` — Updating existing absence

operationId: `updateAbsence`

Id of an employee

### path Parameters

| Parameter | Type | Description |
|---|---|---|
| employeeId *(required)* | string | Id of an employee |
| absenceId *(required)* | string | Id of an absence |

### Request Body schema: application/json *(required)*

| Parameter | Type | Description |
|---|---|---|
| reason *(required)* | string | Currently supported reasons: Injury, Sickness, MaternityLeave, MilitaryLeave, Vacation, InterruptionOfWork. New reasons might be added in the future. |
| start_date *(required)* | string <date> |  |
| end_date *(required)* | string <date> |  |
| half_day *(required)* | boolean Default: False |  |
| continued_pay *(required)* | number |  |
| disability *(required)* | number |  |
| paid_hours *(required)* | number |  |

### Responses

204, 400, 404, 410

**204** — Absence updated

**400** — Malformed content (missing or invalid parameters)

**Response samples** (400):

```json
{
  "status": 400,
  "title": "Malformed content (missing or invalid parameters)"
}
```

**404** — Employee or absence not found

**410** — Employee has been deleted

**Request sample**:

```json
{
  "reason": "Injury",
  "start_date": "2024-01-31",
  "end_date": "2024-01-31",
  "half_day": false,
  "continued_pay": 0,
  "disability": 0,
  "paid_hours": 0
}
```

---

## `DELETE` `/4.0/payroll/employees/{employeeId}/absences/{absenceId}` — Deleting employee absence with given id

operationId: `deleteAbsence`

Id of an employee

### path Parameters

| Parameter | Type | Description |
|---|---|---|
| employeeId *(required)* | string | Id of an employee |
| absenceId *(required)* | string | Id of an absence |

### Responses

204, 400, 404, 410

**204** — Absence deleted

**400** — Malformed request (missing or invalid parameters)

**Response samples** (400):

```json
{
  "status": 400,
  "title": "Malformed request (missing or invalid parameters)"
}
```

**404** — Employee or absence not found

**410** — Employee has been deleted

---
