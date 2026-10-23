# Employees

Part of **Payroll**. Extracted from docs.bexio.com (snapshot Mon, 28 Sep 2026 12:05:15 GMT). 4 operations.

| Method | Path | Title |
|---|---|---|
| `GET` | `/4.0/payroll/employees` | Retrieves all active employees |
| `POST` | `/4.0/payroll/employees` | Create employee |
| `GET` | `/4.0/payroll/employees/{employeeId}` | Retrieve a single employee on a specific date |
| `PATCH` | `/4.0/payroll/employees/{employeeId}` | Update employee |

## `GET` `/4.0/payroll/employees` — Retrieves all active employees

operationId: `getEmployees`

List of all active employees

### Responses

200

**200** — List of all active employees

**Response samples** (200):

```json
{
  "data": [
    {
      "id": "497f6eca-6276-4993-bfeb-53cbbbba6f08",
      "first_name": "string",
      "last_name": "string",
      "date_of_birth": "2024-01-31",
      "ahv_number": "string",
      "gender": "male",
      "nationality": "CH",
      "stay_permit_category": "string",
      "language": "de",
      "marital_status": "unknown",
      "email": "string",
      "phone_number": "string",
      "hours_per_week": 0,
      "employment_level": 0,
      "annual_vacation_days_total": 0,
      "address": {
        "complementary_line": "string",
        "street": "string",
        "street_name": "string",
        "house_number": "string",
        "postbox": "string",
        "locality": "string",
        "zip_code": "string",
        "city": "string",
        "country": "CH",
        "canton": "string",
        "municipality_id": "string"
      },
      "personal_number": "string",
      "iban": "string"
    }
  ]
}
```

---

## `POST` `/4.0/payroll/employees` — Create employee

operationId: `createEmployee`

Nation should be in ISO Alpha-2 format. Special values: '11' means 'unknown', '22' means 'stateless'.

### Request Body schema: application/json *(required)*

| Parameter | Type | Description |
|---|---|---|
| email | string |  |
| first_name | string |  |
| last_name | string |  |
| personal_number | string |  |
| nationality | string | Nation should be in ISO Alpha-2 format. Special values: '11' means 'unknown', '22' means 'stateless'. |
| iban | string |  |
| ahv_number | string |  |
| marital_status | string Default: unknown Enum: unknown single married separated registered_partnership partnership_dissolved_by_law partnership_dissolved_by_death partnership_dissolved_by_declaration_of_lost widowed divorced |  |
| gender | string Enum: male female |  |
| date_of_birth | string <date> |  |
| address | object |  |
| language | string Default: de Enum: de it fr en |  |
| phone_number | string |  |
| annual_vacation_days | integer <int32> |  |

### Responses

201, 400

**201** — Employee created

**Response samples** (201):

```json
{
  "id": "497f6eca-6276-4993-bfeb-53cbbbba6f08",
  "first_name": "string",
  "last_name": "string",
  "date_of_birth": "2024-01-31",
  "ahv_number": "string",
  "gender": "male",
  "nationality": "CH",
  "stay_permit_category": "string",
  "language": "de",
  "marital_status": "unknown",
  "email": "string",
  "phone_number": "string",
  "hours_per_week": 0,
  "employment_level": 0,
  "annual_vacation_days_total": 0,
  "address": {
    "complementary_line": "string",
    "street": "string",
    "street_name": "string",
    "house_number": "string",
    "postbox": "string",
    "locality": "string",
    "zip_code": "string",
    "city": "string",
    "country": "CH",
    "canton": "string",
    "municipality_id": "string"
  },
  "personal_number": "string",
  "iban": "string",
  "annual_vacation_days_used": 0,
  "annual_vacation_days_left": 0,
  "effective_working_hours_per_week": 0
}
```

**400** — Malformed content (missing or invalid parameters)

**Request sample**:

```json
{
  "email": "string",
  "first_name": "string",
  "last_name": "string",
  "personal_number": "string",
  "nationality": "CH",
  "iban": "string",
  "ahv_number": "string",
  "marital_status": "unknown",
  "gender": "male",
  "date_of_birth": "2024-01-31",
  "address": {
    "complementary_line": "string",
    "street": "string",
    "street_name": "string",
    "house_number": "string",
    "postbox": "string",
    "locality": "string",
    "zip_code": "string",
    "city": "string",
    "country": "CH",
    "canton": "string",
    "municipality_id": "string"
  },
  "language": "de",
  "phone_number": "string",
  "annual_vacation_days": 0
}
```

---

## `GET` `/4.0/payroll/employees/{employeeId}` — Retrieve a single employee on a specific date

operationId: `getEmployeeOnDate`

Id of an employee

### path Parameters

| Parameter | Type | Description |
|---|---|---|
| employeeId *(required)* | string | Id of an employee |

### query Parameters

| Parameter | Type | Description |
|---|---|---|
| date *(required)* | string <date> | Date of employee's state |

### Responses

200, 400, 404, 410

**200** — Employee object

**Response samples** (200):

```json
{
  "id": "497f6eca-6276-4993-bfeb-53cbbbba6f08",
  "first_name": "string",
  "last_name": "string",
  "date_of_birth": "2024-01-31",
  "ahv_number": "string",
  "gender": "male",
  "nationality": "CH",
  "stay_permit_category": "string",
  "language": "de",
  "marital_status": "unknown",
  "email": "string",
  "phone_number": "string",
  "hours_per_week": 0,
  "employment_level": 0,
  "annual_vacation_days_total": 0,
  "address": {
    "complementary_line": "string",
    "street": "string",
    "street_name": "string",
    "house_number": "string",
    "postbox": "string",
    "locality": "string",
    "zip_code": "string",
    "city": "string",
    "country": "CH",
    "canton": "string",
    "municipality_id": "string"
  },
  "personal_number": "string",
  "iban": "string",
  "annual_vacation_days_used": 0,
  "annual_vacation_days_left": 0,
  "effective_working_hours_per_week": 0
}
```

**400** — Malformed request (missing or invalid parameters)

**404** — Employee with given id not found

**410** — Employee has been deleted

---

## `PATCH` `/4.0/payroll/employees/{employeeId}` — Update employee

operationId: `updateEmployee`

Id of an employee

### path Parameters

| Parameter | Type | Description |
|---|---|---|
| employeeId *(required)* | string | Id of an employee |

### Request Body schema: application/json *(required)*

| Parameter | Type | Description |
|---|---|---|
| email | string |  |
| first_name | string |  |
| last_name | string |  |
| personal_number | string |  |
| nationality | string | Nation should be in ISO Alpha-2 format. Special values: '11' means 'unknown', '22' means 'stateless'. |
| iban | string |  |
| ahv_number | string |  |
| marital_status | string Default: unknown Enum: unknown single married separated registered_partnership partnership_dissolved_by_law partnership_dissolved_by_death partnership_dissolved_by_declaration_of_lost widowed divorced |  |
| gender | string Enum: male female |  |
| date_of_birth | string <date> |  |
| address | object |  |
| language | string Default: de Enum: de it fr en |  |
| phone_number | string |  |
| annual_vacation_days | integer <int32> |  |

### Responses

204, 400, 404, 410

**204** — Employee updated

**400** — Malformed content (missing or invalid parameters)

**Response samples** (400):

```json
{
  "status": 400,
  "title": "Malformed content (missing or invalid parameters)"
}
```

**404** — Employee with given id not found

**410** — Employee has been deleted

**Request sample**:

```json
{
  "email": "string",
  "first_name": "string",
  "last_name": "string",
  "personal_number": "string",
  "nationality": "CH",
  "iban": "string",
  "ahv_number": "string",
  "marital_status": "unknown",
  "gender": "male",
  "date_of_birth": "2024-01-31",
  "address": {
    "complementary_line": "string",
    "street": "string",
    "street_name": "string",
    "house_number": "string",
    "postbox": "string",
    "locality": "string",
    "zip_code": "string",
    "city": "string",
    "country": "CH",
    "canton": "string",
    "municipality_id": "string"
  },
  "language": "de",
  "phone_number": "string",
  "annual_vacation_days": 0
}
```

---
