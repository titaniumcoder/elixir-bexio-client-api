# Files

Part of **Files**. Extracted from docs.bexio.com (snapshot Mon, 28 Sep 2026 12:05:15 GMT). 9 operations.

| Method | Path | Title |
|---|---|---|
| `GET` | `/3.0/files` | Fetch a list of files |
| `POST` | `/3.0/files` | Create new file |
| `POST` | `/3.0/files/search` | Search files |
| `GET` | `/3.0/files/{file_id}` | Get single file |
| `DELETE` | `/3.0/files/{file_id}` | Delete a existing file |
| `PATCH` | `/3.0/files/{file_id}` | Update existing file |
| `GET` | `/3.0/files/{file_id}/download` | Download file |
| `GET` | `/3.0/files/{file_id}/preview` | Get file preview |
| `GET` | `/3.0/files/{file_id}/usage` | Show file usage |

## `GET` `/3.0/files` — Fetch a list of files

operationId: `v3ReadFiles`

This action provides a list of files which are uploaded to a certain company

### query Parameters

| Parameter | Type | Description |
|---|---|---|
| archived_state | string | Include/Exclude archived files via filter (all, archived, not_archived) |
| offset | integer <int32> Default: 0 | Skip over a number of elements by specifying an offset value for the query |
| order_by | string Default: id Enum: id created_at source_id uuid name size_in_bytes | Defines the order of the results. Multiple sort parameters can be combined by using a comma separator. `_asc` and `_desc` can be appended to any parameter to either sort ascending (default) or descending. |

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

## `POST` `/3.0/files` — Create new file

operationId: `v3CreateFile`

Creates a new file from payload

### Request Body schema: multipart/form-data *(required)*

| Parameter | Type | Description |
|---|---|---|
| file *(required)* | string <binary> | Input path to file |

### Responses

200, 422

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

**422** — Validation error

---

## `POST` `/3.0/files/search` — Search files

operationId: `v3SearchFile`

Search files via query. Please refer to the Search section for detailed instructions.
The following search fields are supported:
- `id`
- `uuid`
- `created_at`
- `name`
- `extension`
- `size_in_bytes`
- `mime_type`
- `user_id`
- `is_archived`
- `source_id`

### query Parameters

| Parameter | Type | Description |
|---|---|---|
| archived_state | string | Include/Exclude archived files via filter (all, archived, not_archived) |
| limit | integer <int32> Default: 500 | Limit the number of results (max is 2000) |
| offset | integer <int32> Default: 0 | Skip over a number of elements by specifying an offset value for the query |

### Request Body schema: application/json *(required)*

| Parameter | Type | Description |
|---|---|---|
| field *(required)* | string | Field which should be search over |
| value *(required)* | string | Value to search for |
| criteria | string Default: like Enum: = == equal != not_equal > greater_than >= greater_equal < less_than <= less_equal like not_like is_null not_null in not_in |  |

### Responses

200, 422

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

**422** — Validation error

**Request sample**:

```json
[
  {
    "field": "name",
    "value": "screenshot"
  }
]
```

---

## `GET` `/3.0/files/{file_id}` — Get single file

operationId: `v3ReadFile`

Tries to query the requested file from the backend

### path Parameters

| Parameter | Type | Description |
|---|---|---|
| file_id *(required)* | integer <int32> | File ID to show |

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
  "created_at": "2018-06-09T08:52:10+00:00"
}
```

---

## `DELETE` `/3.0/files/{file_id}` — Delete a existing file

operationId: `v3DeleteFile`

Sets state of a file to deleted. It cannot be undone.

### path Parameters

| Parameter | Type | Description |
|---|---|---|
| file_id *(required)* | integer <int32> | File ID to show |

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

## `PATCH` `/3.0/files/{file_id}` — Update existing file

operationId: `v3UpdateFile`

Updates a existing file with provided properties

### path Parameters

| Parameter | Type | Description |
|---|---|---|
| file_id *(required)* | integer <int32> | File ID to show |

### Request Body schema: application/json *(required)*

| Parameter | Type | Description |
|---|---|---|
| name | string | The name of the file |
| is_archived | boolean | Define archived state |
| source_type | string or null Enum: web email mobile | type of the source (web, mobile, etc.) this file has been uploaded from |

### Responses

200, 422

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
  "created_at": "2018-06-09T08:52:10+00:00"
}
```

**422** — Validation error

**Request sample**:

```json
{
  "name": "screenshot",
  "is_archived": true,
  "source_type": "web"
}
```

---

## `GET` `/3.0/files/{file_id}/download` — Download file

operationId: `v3DownloadFile`

Provides requested file from backend as stream

### path Parameters

| Parameter | Type | Description |
|---|---|---|
| file_id *(required)* | integer <int32> | File ID to show |

### Responses

200

**200** — OK

**Response samples** (200):

```json
"string"
```

---

## `GET` `/3.0/files/{file_id}/preview` — Get file preview

operationId: `v3PreviewFile`

Provides requested preview for file from backend as stream

### path Parameters

| Parameter | Type | Description |
|---|---|---|
| file_id *(required)* | integer <int32> | File ID to get preview file |

### Responses

200

**200** — OK

**Response samples** (200):

```json
"string"
```

---

## `GET` `/3.0/files/{file_id}/usage` — Show file usage

operationId: `v3ShowFile`

Tries to query the requested file from the backend

### path Parameters

| Parameter | Type | Description |
|---|---|---|
| file_id *(required)* | integer <int32> | File ID to show |

### Responses

200

**200** — OK

**Response samples** (200):

```json
{
  "id": 1,
  "ref_class": "KbInvoice",
  "title": "RE-00001",
  "document_nr": "RE-00001"
}
```

---
