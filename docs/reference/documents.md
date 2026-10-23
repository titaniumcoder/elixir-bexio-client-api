# Documents

Part of **Payroll**. Extracted from docs.bexio.com (snapshot Mon, 28 Sep 2026 12:05:15 GMT). 2 operations.

| Method | Path | Title |
|---|---|---|
| `GET` | `/4.0/payroll/employees/{employeeId}/paystub-pdf/{year}/{month}` | Retrieving pdf for employee for given month Deprecated |
| `GET` | `/4.0/payroll/employees/{employeeId}/paystub-pdf-download/{year}/{month}` | Download paystub pdf for employee for given month |

## `GET` `/4.0/payroll/employees/{employeeId}/paystub-pdf/{year}/{month}` — Retrieving pdf for employee for given month Deprecated

operationId: `getPdfForEmployeeInMonth`

Id of an employee

### path Parameters

| Parameter | Type | Description |
|---|---|---|
| employeeId *(required)* | string | Id of an employee |
| year *(required)* | integer <int32> | Year for which report is being generated |
| month *(required)* | integer <int32> | Month for which report is being generated |

### Responses

200, 400, 404, 410

**200** — Location of generated pdf

**Response samples** (200):

```json
{
  "location": "http://example.com"
}
```

**400** — Malformed request (missing or invalid parameters)

**404** — Employee with given id not found

**410** — Employee has been deleted

---

## `GET` `/4.0/payroll/employees/{employeeId}/paystub-pdf-download/{year}/{month}` — Download paystub pdf for employee for given month

operationId: `downloadPaystubPdf`

Id of an employee

### path Parameters

| Parameter | Type | Description |
|---|---|---|
| employeeId *(required)* | string | Id of an employee |
| year *(required)* | integer <int32> | Year for which report is being generated |
| month *(required)* | integer <int32> | Month for which report is being generated |

### Responses

200, 400, 404, 410

**200** — Generated paystub PDF file

**400** — Malformed request (missing or invalid parameters)

**Response samples** (400):

```json
{
  "status": 400,
  "title": "Malformed request (missing or invalid parameters)"
}
```

**404** — Employee with given id not found

**410** — Employee has been deleted

---
