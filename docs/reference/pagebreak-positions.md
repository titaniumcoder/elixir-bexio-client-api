# Pagebreak positions

Part of **Sales Order Management**. Extracted from docs.bexio.com (snapshot Mon, 28 Sep 2026 12:05:15 GMT). 5 operations.

| Method | Path | Title |
|---|---|---|
| `GET` | `/2.0/{kb_document_type}/{document_id}/kb_position_pagebreak` | Fetch a list of pagebreak positions |
| `POST` | `/2.0/{kb_document_type}/{document_id}/kb_position_pagebreak` | Create a pagebreak position |
| `GET` | `/2.0/{kb_document_type}/{document_id}/kb_position_pagebreak/{position_id}` | Fetch a pagebreak position |
| `POST` | `/2.0/{kb_document_type}/{document_id}/kb_position_pagebreak/{position_id}` | Edit a pagebreak position |
| `DELETE` | `/2.0/{kb_document_type}/{document_id}/kb_position_pagebreak/{position_id}` | Delete a pagebreak position |

## `GET` `/2.0/{kb_document_type}/{document_id}/kb_position_pagebreak` — Fetch a list of pagebreak positions

operationId: `v2ListPagebreakPositions`

This action fetches a list of all pagebreak positions for a document.
If you have an invoice with ID 4 you should replace the path parameter `kb_document_type` with kb_invoice and replace the path parameter `document_id` with `4`.

### path Parameters

| Parameter | Type | Description |
|---|---|---|
| kb_document_type *(required)* | string Enum: kb_offer kb_order kb_invoice | The type of the document. Pagebreak positions can be added to quotes, orders and invoices |
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
    "id": 1,
    "internal_pos": 1,
    "is_optional": false,
    "type": "KbPositionPagebreak",
    "parent_id": null
  }
]
```

---

## `POST` `/2.0/{kb_document_type}/{document_id}/kb_position_pagebreak` — Create a pagebreak position

operationId: `v2CreatePagebreakPosition`

This action creates a new pagebreak position for a document
If you have an invoice with ID 4 you should replace the path parameter `kb_document_type` with kb_invoice and replace the path parameter `document_id` with `4`.

### path Parameters

| Parameter | Type | Description |
|---|---|---|
| kb_document_type *(required)* | string Enum: kb_offer kb_order kb_invoice | The type of the document. Pagebreak positions can be added to quotes, orders and invoices |
| document_id *(required)* | integer <int32> | the id of the document. E.g. if the `kb_document_type` is set to `kb_invoice` the `document_id` must be set to the ID of the invoice |

### Request Body schema: application/json *(required)*

| Parameter | Type | Description |
|---|---|---|
| pagebreak | boolean |  |

### Responses

201, 422

**201** — Created

**Response samples** (201):

```json
{
  "id": 1,
  "internal_pos": 1,
  "is_optional": false,
  "type": "KbPositionPagebreak",
  "parent_id": null
}
```

**422** — Validation error

**Request sample**:

```json
{
  "pagebreak": true
}
```

---

## `GET` `/2.0/{kb_document_type}/{document_id}/kb_position_pagebreak/{position_id}` — Fetch a pagebreak position

operationId: `v2ShowPagebreakPosition`

This action fetches a single pagebreak position for a document.
If you have an invoice with ID 4 you should replace the path parameter `kb_document_type` with kb_invoice and replace the path parameter `document_id` with `4`.

### path Parameters

| Parameter | Type | Description |
|---|---|---|
| kb_document_type *(required)* | string Enum: kb_offer kb_order kb_invoice | The type of the document. Pagebreak positions can be added to quotes, orders and invoices |
| document_id *(required)* | integer <int32> | the id of the document. E.g. if the `kb_document_type` is set to `kb_invoice` the `document_id` must be set to the ID of the invoice |
| position_id *(required)* | integer <int32> | the id of the position |

### Responses

200

**200** — OK

**Response samples** (200):

```json
{
  "id": 1,
  "internal_pos": 1,
  "is_optional": false,
  "type": "KbPositionPagebreak",
  "parent_id": null
}
```

---

## `POST` `/2.0/{kb_document_type}/{document_id}/kb_position_pagebreak/{position_id}` — Edit a pagebreak position

operationId: `v2EditPagebreakPosition`

This action edits a single pagebreak position for a document
If you have an invoice with ID 4 you should replace the path parameter `kb_document_type` with kb_invoice and replace the path parameter `document_id` with `4`.

### path Parameters

| Parameter | Type | Description |
|---|---|---|
| kb_document_type *(required)* | string Enum: kb_offer kb_order kb_invoice | The type of the document. Pagebreak positions can be added to quotes, orders and invoices |
| document_id *(required)* | integer <int32> | the id of the document. E.g. if the `kb_document_type` is set to `kb_invoice` the `document_id` must be set to the ID of the invoice |
| position_id *(required)* | integer <int32> | the id of the position |

### Request Body schema: application/json

| Parameter | Type | Description |
|---|---|---|
| pagebreak | boolean |  |

### Responses

200, 422

**200** — OK

**Response samples** (200):

```json
{
  "id": 1,
  "internal_pos": 1,
  "is_optional": false,
  "type": "KbPositionPagebreak",
  "parent_id": null
}
```

**422** — Validation error

**Request sample**:

```json
{
  "pagebreak": true
}
```

---

## `DELETE` `/2.0/{kb_document_type}/{document_id}/kb_position_pagebreak/{position_id}` — Delete a pagebreak position

operationId: `v2DeletePagebreakPosition`

This action permanently deletes a pagebreak position for a document. It cannot be undone.
If you have an invoice with ID 4 you should replace the path parameter `kb_document_type` with kb_invoice and replace the path parameter `document_id` with `4`.

### path Parameters

| Parameter | Type | Description |
|---|---|---|
| kb_document_type *(required)* | string Enum: kb_offer kb_order kb_invoice | The type of the document. Pagebreak positions can be added to quotes, orders and invoices |
| document_id *(required)* | integer <int32> | the id of the document. E.g. if the `kb_document_type` is set to `kb_invoice` the `document_id` must be set to the ID of the invoice |
| position_id *(required)* | integer <int32> | the id of the position |

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
