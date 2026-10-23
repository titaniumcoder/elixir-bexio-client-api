# Comments

Part of **Sales Order Management**. Extracted from docs.bexio.com (snapshot Mon, 28 Sep 2026 12:05:15 GMT). 3 operations.

| Method | Path | Title |
|---|---|---|
| `GET` | `/2.0/{kb_document_type}/{document_id}/comment` | Fetch a list of comments |
| `POST` | `/2.0/{kb_document_type}/{document_id}/comment` | Create a comment |
| `GET` | `/2.0/{kb_document_type}/{document_id}/comment/{comment_id}` | Fetch a comment |

## `GET` `/2.0/{kb_document_type}/{document_id}/comment` — Fetch a list of comments

operationId: `v2ListComments`

This action fetches a list of all comments for a document.
If you have an invoice with ID 4 you should replace the path parameter `kb_document_type` with kb_invoice and replace the path parameter `document_id` with `4`.

### path Parameters

| Parameter | Type | Description |
|---|---|---|
| kb_document_type *(required)* | string Enum: kb_offer kb_order kb_invoice | The type of the document. Item positions can be added to quotes, orders and invoices |
| document_id *(required)* | integer <int32> | the id of the document. E.g. if the `kb_document_type` is set to `kb_invoice` the `document_id` must be set to the ID of the invoice |

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
    "text": "Sample comment",
    "user_id": 1,
    "user_email": null,
    "user_name": "Peter Smith",
    "date": "2019-07-18 15:41:53",
    "is_public": false,
    "image": "R0lGODlhAQABAIAAAAUEBAAAACwAAAAAAQABAAACAkQBADs=",
    "image_path": "https://my.bexio.com/img/profile_picture/j2cbWl-yp3zT9oOh9jHTAA/Ds8buEV0HXZsvuBm3df8SQ.png?type=thumb"
  }
]
```

---

## `POST` `/2.0/{kb_document_type}/{document_id}/comment` — Create a comment

operationId: `v2CreateComment`

This action creates a new comment for a document
If you have an invoice with ID 4 you should replace the path parameter `kb_document_type` with kb_invoice and replace the path parameter `document_id` with `4`.

### path Parameters

| Parameter | Type | Description |
|---|---|---|
| kb_document_type *(required)* | string Enum: kb_offer kb_order kb_invoice | The type of the document. Comments can be added to quotes, orders and invoices |
| document_id *(required)* | integer <int32> | the id of the document. E.g. if the `kb_document_type` is set to `kb_invoice` the `document_id` must be set to the ID of the invoice |

### Request Body schema: application/json *(required)*

| Parameter | Type | Description |
|---|---|---|
| text *(required)* | string |  |
| user_id *(required)* | integer or null | References a user object |
| user_email | string or null |  |
| user_name *(required)* | string or null |  |
| is_public | boolean |  |

### Responses

201, 422

**201** — Created

**Response samples** (201):

```json
{
  "id": 4,
  "text": "Sample comment",
  "user_id": 1,
  "user_email": null,
  "user_name": "Peter Smith",
  "date": "2019-07-18 15:41:53",
  "is_public": false,
  "image": "R0lGODlhAQABAIAAAAUEBAAAACwAAAAAAQABAAACAkQBADs=",
  "image_path": "https://my.bexio.com/img/profile_picture/j2cbWl-yp3zT9oOh9jHTAA/Ds8buEV0HXZsvuBm3df8SQ.png?type=thumb"
}
```

**422** — Validation error

**Request sample**:

```json
{
  "text": "Sample comment",
  "user_id": 1,
  "user_email": null,
  "user_name": "Peter Smith",
  "is_public": false
}
```

---

## `GET` `/2.0/{kb_document_type}/{document_id}/comment/{comment_id}` — Fetch a comment

operationId: `v2ShowComment`

This action fetches a single comment for a document.
If you have an invoice with ID 4 you should replace the path parameter `kb_document_type` with kb_invoice and replace the path parameter `document_id` with `4`.

### path Parameters

| Parameter | Type | Description |
|---|---|---|
| kb_document_type *(required)* | string Enum: kb_offer kb_order kb_invoice | The type of the document. Comments can be used in quotes, orders and invoices |
| document_id *(required)* | integer <int32> | the id of the document. E.g. if the `kb_document_type` is set to `kb_invoice` the `document_id` must be set to the ID of the invoice |
| comment_id *(required)* | integer <int32> | the id of the comment |

### Responses

200

**200** — OK

**Response samples** (200):

```json
{
  "id": 4,
  "text": "Sample comment",
  "user_id": 1,
  "user_email": null,
  "user_name": "Peter Smith",
  "date": "2019-07-18 15:41:53",
  "is_public": false,
  "image": "R0lGODlhAQABAIAAAAUEBAAAACwAAAAAAQABAAACAkQBADs=",
  "image_path": "https://my.bexio.com/img/profile_picture/j2cbWl-yp3zT9oOh9jHTAA/Ds8buEV0HXZsvuBm3df8SQ.png?type=thumb"
}
```

---
