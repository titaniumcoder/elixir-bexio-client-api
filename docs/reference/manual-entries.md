# Manual Entries

Part of **Accounting**. Extracted from docs.bexio.com (snapshot Mon, 28 Sep 2026 12:05:15 GMT). 13 operations.

| Method | Path | Title |
|---|---|---|
| `GET` | `/3.0/accounting/manual_entries` | Fetch a list of manual entries |
| `POST` | `/3.0/accounting/manual_entries` | Create manual entry |
| `PUT` | `/3.0/accounting/manual_entries/{manual_entry_id}` | Update manual entry |
| `DELETE` | `/3.0/accounting/manual_entries/{manual_entry_id}` | Delete manual entry |
| `GET` | `/3.0/accounting/manual_entries/next_ref_nr` | Get next reference number |
| `GET` | `/3.0/accounting/manual_entries/{manual_entry_id}/entries/{entry_id}/files` | Fetch files of manual entry line |
| `POST` | `/3.0/accounting/manual_entries/{manual_entry_id}/entries/{entry_id}/files` | Add file to manual entry line |
| `GET` | `/3.0/accounting/manual_entries/{manual_entry_id}/entries/{entry_id}/files/{file_id}` | Fetch file of manual entry line |
| `DELETE` | `/3.0/accounting/manual_entries/{manual_entry_id}/entries/{entry_id}/files/{file_id}` | Delete connection between file and manual entry line |
| `GET` | `/3.0/accounting/manual_entries/{manual_entry_id}/files` | Fetch files of manual compound entry |
| `POST` | `/3.0/accounting/manual_entries/{manual_entry_id}/files` | Add file to manual compound entry |
| `GET` | `/3.0/accounting/manual_entries/{manual_entry_id}/files/{file_id}` | Fetch file of manual compound entry |
| `DELETE` | `/3.0/accounting/manual_entries/{manual_entry_id}/files/{file_id}` | Delete connection between file and manual compound entry |

## `GET` `/3.0/accounting/manual_entries` — Fetch a list of manual entries

operationId: `ListManualEntries`

This action fetches a list of all manual entries which have been added in the accounting module

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
    "id": 1,
    "type": "manual_single_entry",
    "date": "2019-11-17",
    "reference_nr": "Booking BA-22",
    "created_by_user_id": 1,
    "edited_by_user_id": 1,
    "entries": [
      {
        "id": 32,
        "date": "2019-11-17",
        "debit_account_id": 77,
        "credit_account_id": 139,
        "tax_id": 3,
        "tax_account_id": 77,
        "description": "Payment for client Smith",
        "amount": 328.25,
        "currency_id": 1,
        "base_currency_id": 1,
        "currency_factor": 1,
        "base_currency_amount": 328.25,
        "created_by_user_id": 1,
        "edited_by_user_id": 1
      }
    ],
    "is_locked": false,
    "locked_info": "closed_business_year"
  }
]
```

---

## `POST` `/3.0/accounting/manual_entries` — Create manual entry

operationId: `CreateManualEntry`

This action creates a new manual entry for the account ledger

### Request Body schema: application/json *(required)*

| Parameter | Type | Description |
|---|---|---|
| type *(required)* | string Enum: manual_single_entry manual_compound_entry manual_group_entry | Choose one of the following three types: manual_single_entry Can be used to create a simple one line booking such as: debit account credit account amount 1020 3200 13600 manual_compound_entry Can be used to create a more complex booking where the total amount can be distributed among multiple accounts. The following example shows how a received bank transaction can be booked on multiple accounts: debit account credit account amount 1020 25000 3200 10000 3201 8000 3202 7000 manual_group_entry Can be used to create multiple one line bookings in one group entry. This means that the bookings will have the same `reference_nr` but can differ in accounts, currencies, etc. The following example shows how two received bank transaction can be booked on different accounts: debit account credit account amount 1020 3200 13600 1021 3201 7230 |
| date *(required)* | string <date> | the booking date |
| reference_nr | string | A reference number for the booking |
| entries *(required)* | array |  |

### Responses

201, 422

**201** — Created

**Response samples** (201):

```json
{
  "id": 1,
  "type": "manual_single_entry",
  "date": "2019-11-17",
  "reference_nr": "Booking BA-22",
  "created_by_user_id": 1,
  "edited_by_user_id": 1,
  "entries": [
    {
      "id": 32,
      "date": "2019-11-17",
      "debit_account_id": 77,
      "credit_account_id": 139,
      "tax_id": 3,
      "tax_account_id": 77,
      "description": "Payment for client Smith",
      "amount": 328.25,
      "currency_id": 1,
      "base_currency_id": 1,
      "currency_factor": 1,
      "base_currency_amount": 328.25,
      "created_by_user_id": 1,
      "edited_by_user_id": 1
    }
  ],
  "is_locked": false,
  "locked_info": "closed_business_year"
}
```

**422** — Validation error

**Request sample**:

```json
{
  "type": "manual_single_entry",
  "date": "2019-11-17",
  "reference_nr": "Booking BA-22",
  "entries": [
    {
      "debit_account_id": 77,
      "credit_account_id": 139,
      "tax_id": 3,
      "tax_account_id": 77,
      "description": "Payment for client Smith",
      "amount": 328.25,
      "currency_id": 1,
      "currency_factor": 1
    }
  ]
}
```

---

## `PUT` `/3.0/accounting/manual_entries/{manual_entry_id}` — Update manual entry

operationId: `UpdateManualEntry`

This action updates a manual entry

### Request Body schema: application/json *(required)*

| Parameter | Type | Description |
|---|---|---|
| type *(required)* | string Enum: manual_single_entry manual_compound_entry manual_group_entry | Choose one of the following three types: manual_single_entry Can be used to create a simple one line booking such as: debit account credit account amount 1020 3200 13600 manual_compound_entry Can be used to create a more complex booking where the total amount can be distributed among multiple accounts. The following example shows how a received bank transaction can be booked on multiple accounts: debit account credit account amount 1020 25000 3200 10000 3201 8000 3202 7000 manual_group_entry Can be used to create multiple one line bookings in one group entry. This means that the bookings will have the same `reference_nr` but can differ in accounts, currencies, etc. The following example shows how two received bank transaction can be booked on different accounts: debit account credit account amount 1020 3200 13600 1021 3201 7230 |
| date *(required)* | string <date> | the booking date |
| reference_nr | string | A reference number for the booking |
| entries *(required)* | array |  |
| id | number | The id of the main resource |

### Responses

200, 422

**200** — Created

**Response samples** (200):

```json
{
  "id": 1,
  "type": "manual_single_entry",
  "date": "2019-11-17",
  "reference_nr": "Booking BA-22",
  "created_by_user_id": 1,
  "edited_by_user_id": 1,
  "entries": [
    {
      "id": 32,
      "date": "2019-11-17",
      "debit_account_id": 77,
      "credit_account_id": 139,
      "tax_id": 3,
      "tax_account_id": 77,
      "description": "Payment for client Smith",
      "amount": 328.25,
      "currency_id": 1,
      "base_currency_id": 1,
      "currency_factor": 1,
      "base_currency_amount": 328.25,
      "created_by_user_id": 1,
      "edited_by_user_id": 1
    }
  ],
  "is_locked": false,
  "locked_info": "closed_business_year"
}
```

**422** — Validation error

**Request sample**:

```json
{
  "type": "manual_single_entry",
  "date": "2019-11-17",
  "reference_nr": "Booking BA-22",
  "entries": [
    {
      "debit_account_id": 77,
      "credit_account_id": 139,
      "tax_id": 3,
      "tax_account_id": 77,
      "description": "Payment for client Smith",
      "amount": 328.25,
      "currency_id": 1,
      "currency_factor": 1,
      "id": 2
    }
  ],
  "id": 1
}
```

---

## `DELETE` `/3.0/accounting/manual_entries/{manual_entry_id}` — Delete manual entry

operationId: `DeleteManualEntry`

This action permanently deletes a manual entry. It cannot be undone. It also deletes the connection between the specific manual entry and any linked files.

### path Parameters

| Parameter | Type | Description |
|---|---|---|
| manual_entry_id *(required)* | integer <int32> | the id of the manual_entry |

### Responses

200, 422

**200** — OK

**Response samples** (200):

```json
{
  "success": true
}
```

**422** — Validation error

---

## `GET` `/3.0/accounting/manual_entries/next_ref_nr` — Get next reference number

operationId: `GetNextReferenceNumber`

This action can be used to get the next reference number for a manual entry

### Responses

200, 422

**200** — OK

**Response samples** (200):

```json
{
  "next_ref_nr": "Booking BA-22"
}
```

**422** — Validation error

---

## `GET` `/3.0/accounting/manual_entries/{manual_entry_id}/entries/{entry_id}/files` — Fetch files of manual entry line

operationId: `ListManualEntryFiles`

This action fetches a list of all files associated to a specific manual entry line

### path Parameters

| Parameter | Type | Description |
|---|---|---|
| manual_entry_id *(required)* | integer <int32> | the id of the manual_entry |
| entry_id *(required)* | integer <int32> | the id of a single entry in the manual_entry object |

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
    "id": 1,
    "uuid": "474cc93a-2d6f-47e9-bd3f-a5b5a1941314",
    "name": "screenshot",
    "size_in_bytes": 218476,
    "extension": "png",
    "mime_type": "image/png",
    "uploader_email": "contact@example.org",
    "user_id": 1,
    "is_archived": false,
    "source_id": 2,
    "source_type": "web",
    "is_referenced": false,
    "created_at": "2018-06-09T08:52:10+00:00"
  }
]
```

---

## `POST` `/3.0/accounting/manual_entries/{manual_entry_id}/entries/{entry_id}/files` — Add file to manual entry line

operationId: `UploadManualEntryFile`

This action uploads one or multiple files and attaches the files to an existing accounting entry line (only for entry types manual_single_entry and manual_group_entry)
Please note that you must set the content-type to `multipart/form-data`.
You can upload multiple files with one request by providing different identifiers (e.g. `fileName1` and `fileName2`). Max. file size is 12MB and supported file formats are PNG, JPG, JPEG, GIF, DOC, DOCX, XLS, XLSX, PPT, PPTX, PDF.

### path Parameters

| Parameter | Type | Description |
|---|---|---|
| manual_entry_id *(required)* | integer <int32> | the id of the manual_entry |
| entry_id *(required)* | integer <int32> | the id of a single entry in the manual_entry object |

### Request Body schema: multipart/form-data *(required)*

| Parameter | Type | Description |
|---|---|---|

### Responses

201, 422

**201** — Created

**Response samples** (201):

```json
[
  {
    "id": 1,
    "uuid": "474cc93a-2d6f-47e9-bd3f-a5b5a1941314",
    "name": "screenshot",
    "size_in_bytes": 218476,
    "extension": "png",
    "mime_type": "image/png",
    "uploader_email": "contact@example.org",
    "user_id": 1,
    "is_archived": false,
    "source_id": 2,
    "source_type": "web",
    "is_referenced": false,
    "created_at": "2018-06-09T08:52:10+00:00"
  }
]
```

**422** — Validation error

---

## `GET` `/3.0/accounting/manual_entries/{manual_entry_id}/entries/{entry_id}/files/{file_id}` — Fetch file of manual entry line

operationId: `ShowManualEntryFile`

This action fetches a file associated to a specific manual entry line (only for entry types manual_single_entry and manual_group_entry)

### path Parameters

| Parameter | Type | Description |
|---|---|---|
| manual_entry_id *(required)* | integer <int32> | the id of the manual_entry |
| entry_id *(required)* | integer <int32> | the id of a single entry in the manual_entry object |
| file_id *(required)* | integer <int32> | the id of the file |

### Responses

200

**200** — OK

**Response samples** (200):

```json
{
  "id": 1,
  "uuid": "474cc93a-2d6f-47e9-bd3f-a5b5a1941314",
  "name": "screenshot",
  "size_in_bytes": 218476,
  "extension": "png",
  "mime_type": "image/png",
  "uploader_email": "contact@example.org",
  "user_id": 1,
  "is_archived": false,
  "source_id": 2,
  "source_type": "web",
  "is_referenced": false,
  "created_at": "2018-06-09T08:52:10+00:00",
  "data": "iVBORw0KGgoAAAANSUhEUgAAAQAAAAEACAIAAADTED8xAAAACXBIWXMAAABIAAAASABGyWs+AAACu0lEQVR42u3TAQkAMBDEsHuYf80T0oRa6G07qdrbDbIMQJoBSDMAaQYgzQCkGYA0A5BmANIMQJoBSDMAaQYgzQCkGYA0A5BmANIMQJoBSDMAaQYgzQCkGYA0A5BmANIMQJoBSDMAaQYgzQCkGYA0A5BmANIMQJoBSDMAaQYgzQCkGYA0A5BmANIMQJoBSDMAaQYgzQCkGYA0A5BmANIMQJoBSDMAaQYgzQCkGYA0A5BmANIMQJoBSDMAaQYgzQCkGYA0A5BmANIMQJoBSDMAaQYgzQCkGYA0A5BmANIMQJoBSDMAaQYgzQCkGYA0A5BmANIMQJoBSDMAaQYgzQCkGYA0A5BmANIMQJoBSDMAaQYgzQCkGYA0A5BmANIMQJoBSDMAaQYgzQCkGYA0A5BmANIMQJoBSDMAaQYgzQCkGYA0A5BmANIMQJoBSDMAaQYgzQCkGYA0A5BmANIMQJoBSDMAaQYgzQCkGYA0A5BmANIMQJoBSDMAaQYgzQCkGYA0A5BmANIMQJoBSDMAaQYgzQCkGYA0A5BmANIMQJoBSDMAaQYgzQCkGYA0A5BmANIMQJoBSDMAaQYgzQCkGYA0A5BmANIMQJoBSDMAaQYgzQCkGYA0A5BmANIMQJoBSDMAaQYgzQCkGYA0A5BmANIMQJoBSDMAaQYgzQCkGYA0A5BmANIMQJoBSDMAaQYgzQCkGYA0A5BmANIMQJoBSDMAaQYgzQCkGYA0A5BmANIMQJoBSDMAaQYgzQCkGYA0A5BmANIMQJoBSDMAaQYgzQCkGYA0A5BmANIMQJoBSDMAaQYgzQCkGYA0A5BmANIMQJoBSDMAaQYgzQCkGYA0A5BmANIMQJoBSDMAaQYgzQCkGYA0A5BmANIMQJoBSDMAaQYgzQCkGYA0A5BmANIMQJoBSDMAaQYgzQCkGYC0DxplBfxP7XIvAAAAAElFTkSuQmCC"
}
```

---

## `DELETE` `/3.0/accounting/manual_entries/{manual_entry_id}/entries/{entry_id}/files/{file_id}` — Delete connection between file and manual entry line

operationId: `DeleteManualEntryFile`

This action deletes the connection between the file and the specific manual entry line (only for entry types manual_single_entry and manual_group_entry).

### path Parameters

| Parameter | Type | Description |
|---|---|---|
| manual_entry_id *(required)* | integer <int32> | the id of the manual_entry |
| entry_id *(required)* | integer <int32> | the id of a single entry in the manual_entry object |
| file_id *(required)* | integer <int32> | the id of the currency |

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

## `GET` `/3.0/accounting/manual_entries/{manual_entry_id}/files` — Fetch files of manual compound entry

operationId: `ListManualCompoundEntryFiles`

This action fetches a list of all files associated with a specific manual compound entry

### path Parameters

| Parameter | Type | Description |
|---|---|---|
| manual_entry_id *(required)* | integer <int32> | the id of the manual_entry |

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
    "id": 1,
    "uuid": "474cc93a-2d6f-47e9-bd3f-a5b5a1941314",
    "name": "screenshot",
    "size_in_bytes": 218476,
    "extension": "png",
    "mime_type": "image/png",
    "uploader_email": "contact@example.org",
    "user_id": 1,
    "is_archived": false,
    "source_id": 2,
    "source_type": "web",
    "is_referenced": false,
    "created_at": "2018-06-09T08:52:10+00:00"
  }
]
```

---

## `POST` `/3.0/accounting/manual_entries/{manual_entry_id}/files` — Add file to manual compound entry

operationId: `UploadManualCompoundEntryFile`

This action uploads one or multiple files and attaches the files to an existing manual compound entry
Please note that you must set the content-type to `multipart/form-data`.
You can upload multiple files with one request by providing different identifiers (e.g. `fileName1` and `fileName2`). Max. file size is 12MB and supported file formats are PNG, JPG, JPEG, GIF, DOC, DOCX, XLS, XLSX, PPT, PPTX, PDF.

### path Parameters

| Parameter | Type | Description |
|---|---|---|
| manual_entry_id *(required)* | integer <int32> | the id of the manual_entry |

### Request Body schema: multipart/form-data *(required)*

| Parameter | Type | Description |
|---|---|---|

### Responses

201, 422

**201** — Created

**Response samples** (201):

```json
[
  {
    "id": 1,
    "uuid": "474cc93a-2d6f-47e9-bd3f-a5b5a1941314",
    "name": "screenshot",
    "size_in_bytes": 218476,
    "extension": "png",
    "mime_type": "image/png",
    "uploader_email": "contact@example.org",
    "user_id": 1,
    "is_archived": false,
    "source_id": 2,
    "source_type": "web",
    "is_referenced": false,
    "created_at": "2018-06-09T08:52:10+00:00"
  }
]
```

**422** — Validation error

---

## `GET` `/3.0/accounting/manual_entries/{manual_entry_id}/files/{file_id}` — Fetch file of manual compound entry

operationId: `ShowManualCompoundEntryFile`

This action fetches a file associated with a specific compound entry

### path Parameters

| Parameter | Type | Description |
|---|---|---|
| manual_entry_id *(required)* | integer <int32> | the id of the manual_entry |
| file_id *(required)* | integer <int32> | the id of the file |

### Responses

200

**200** — OK

**Response samples** (200):

```json
{
  "id": 1,
  "uuid": "474cc93a-2d6f-47e9-bd3f-a5b5a1941314",
  "name": "screenshot",
  "size_in_bytes": 218476,
  "extension": "png",
  "mime_type": "image/png",
  "uploader_email": "contact@example.org",
  "user_id": 1,
  "is_archived": false,
  "source_id": 2,
  "source_type": "web",
  "is_referenced": false,
  "created_at": "2018-06-09T08:52:10+00:00",
  "data": "iVBORw0KGgoAAAANSUhEUgAAAQAAAAEACAIAAADTED8xAAAACXBIWXMAAABIAAAASABGyWs+AAACu0lEQVR42u3TAQkAMBDEsHuYf80T0oRa6G07qdrbDbIMQJoBSDMAaQYgzQCkGYA0A5BmANIMQJoBSDMAaQYgzQCkGYA0A5BmANIMQJoBSDMAaQYgzQCkGYA0A5BmANIMQJoBSDMAaQYgzQCkGYA0A5BmANIMQJoBSDMAaQYgzQCkGYA0A5BmANIMQJoBSDMAaQYgzQCkGYA0A5BmANIMQJoBSDMAaQYgzQCkGYA0A5BmANIMQJoBSDMAaQYgzQCkGYA0A5BmANIMQJoBSDMAaQYgzQCkGYA0A5BmANIMQJoBSDMAaQYgzQCkGYA0A5BmANIMQJoBSDMAaQYgzQCkGYA0A5BmANIMQJoBSDMAaQYgzQCkGYA0A5BmANIMQJoBSDMAaQYgzQCkGYA0A5BmANIMQJoBSDMAaQYgzQCkGYA0A5BmANIMQJoBSDMAaQYgzQCkGYA0A5BmANIMQJoBSDMAaQYgzQCkGYA0A5BmANIMQJoBSDMAaQYgzQCkGYA0A5BmANIMQJoBSDMAaQYgzQCkGYA0A5BmANIMQJoBSDMAaQYgzQCkGYA0A5BmANIMQJoBSDMAaQYgzQCkGYA0A5BmANIMQJoBSDMAaQYgzQCkGYA0A5BmANIMQJoBSDMAaQYgzQCkGYA0A5BmANIMQJoBSDMAaQYgzQCkGYA0A5BmANIMQJoBSDMAaQYgzQCkGYA0A5BmANIMQJoBSDMAaQYgzQCkGYA0A5BmANIMQJoBSDMAaQYgzQCkGYA0A5BmANIMQJoBSDMAaQYgzQCkGYA0A5BmANIMQJoBSDMAaQYgzQCkGYA0A5BmANIMQJoBSDMAaQYgzQCkGYA0A5BmANIMQJoBSDMAaQYgzQCkGYA0A5BmANIMQJoBSDMAaQYgzQCkGYA0A5BmANIMQJoBSDMAaQYgzQCkGYC0DxplBfxP7XIvAAAAAElFTkSuQmCC"
}
```

---

## `DELETE` `/3.0/accounting/manual_entries/{manual_entry_id}/files/{file_id}` — Delete connection between file and manual compound entry

operationId: `DeleteManualCompoundEntryFile`

This action deletes the connection between the file and the specific manual compound entry

### path Parameters

| Parameter | Type | Description |
|---|---|---|
| manual_entry_id *(required)* | integer <int32> | the id of the manual_entry |
| file_id *(required)* | integer <int32> | the id of the currency |

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
