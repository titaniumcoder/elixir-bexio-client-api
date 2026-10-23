# Text positions

Part of **Sales Order Management**. Extracted from docs.bexio.com (snapshot Mon, 28 Sep 2026 12:05:15 GMT). 5 operations.

| Method | Path | Title |
|---|---|---|
| `GET` | `/2.0/{kb_document_type}/{document_id}/kb_position_text` | Fetch a list of text positions |
| `POST` | `/2.0/{kb_document_type}/{document_id}/kb_position_text` | Create a text position |
| `GET` | `/2.0/{kb_document_type}/{document_id}/kb_position_text/{position_id}` | Fetch a text position |
| `POST` | `/2.0/{kb_document_type}/{document_id}/kb_position_text/{position_id}` | Edit a text position |
| `DELETE` | `/2.0/{kb_document_type}/{document_id}/kb_position_text/{position_id}` | Delete a text position |

## `GET` `/2.0/{kb_document_type}/{document_id}/kb_position_text` — Fetch a list of text positions

operationId: `v2ListTextPositions`

This action fetches a list of all text positions for a document.
If you have an invoice with ID 4 you should replace the path parameter `kb_document_type` with kb_invoice and replace the path parameter `document_id` with `4`.

### path Parameters

| Parameter | Type | Description |
|---|---|---|
| kb_document_type *(required)* | string Enum: kb_offer kb_order kb_invoice | The type of the document. Text positions can be added to quotes, orders and invoices |
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
    "text": "This position type allows to add free text to a document",
    "show_pos_nr": false,
    "pos": null,
    "internal_pos": 1,
    "is_optional": false,
    "type": "KbPositionText",
    "parent_id": null
  }
]
```

---

## `POST` `/2.0/{kb_document_type}/{document_id}/kb_position_text` — Create a text position

operationId: `v2CreateTextPosition`

This action creates a new text position for a document
If you have an invoice with ID 4 you should replace the path parameter `kb_document_type` with kb_invoice and replace the path parameter `document_id` with `4`.

### path Parameters

| Parameter | Type | Description |
|---|---|---|
| kb_document_type *(required)* | string Enum: kb_offer kb_order kb_invoice | The type of the document. Text positions can be added to quotes, orders and invoices |
| document_id *(required)* | integer <int32> | the id of the document. E.g. if the `kb_document_type` is set to `kb_invoice` the `document_id` must be set to the ID of the invoice |

### Request Body schema: application/json *(required)*

| Parameter | Type | Description |
|---|---|---|
| text | string |  |
| show_pos_nr | boolean |  |

### Responses

201, 422

**201** — Created

**Response samples** (201):

```json
{
  "id": 1,
  "text": "This position type allows to add free text to a document",
  "show_pos_nr": false,
  "pos": null,
  "internal_pos": 1,
  "is_optional": false,
  "type": "KbPositionText",
  "parent_id": null
}
```

**422** — Validation error

**Request sample**:

```json
{
  "text": "This position type allows to add free text to a document",
  "show_pos_nr": false
}
```

---

## `GET` `/2.0/{kb_document_type}/{document_id}/kb_position_text/{position_id}` — Fetch a text position

operationId: `v2ShowTextPosition`

This action fetches a single text position for a document.
If you have an invoice with ID 4 you should replace the path parameter `kb_document_type` with kb_invoice and replace the path parameter `document_id` with `4`.

### path Parameters

| Parameter | Type | Description |
|---|---|---|
| kb_document_type *(required)* | string Enum: kb_offer kb_order kb_invoice | The type of the document. Text positions can be added to quotes, orders and invoices |
| document_id *(required)* | integer <int32> | the id of the document. E.g. if the `kb_document_type` is set to `kb_invoice` the `document_id` must be set to the ID of the invoice |
| position_id *(required)* | integer <int32> | the id of the position |

### Responses

200

**200** — OK

**Response samples** (200):

```json
{
  "id": 1,
  "text": "This position type allows to add free text to a document",
  "show_pos_nr": false,
  "pos": null,
  "internal_pos": 1,
  "is_optional": false,
  "type": "KbPositionText",
  "parent_id": null
}
```

---

## `POST` `/2.0/{kb_document_type}/{document_id}/kb_position_text/{position_id}` — Edit a text position

operationId: `v2EditTextPosition`

This action edits a single text position for a document
If you have an invoice with ID 4 you should replace the path parameter `kb_document_type` with kb_invoice and replace the path parameter `document_id` with `4`.

### path Parameters

| Parameter | Type | Description |
|---|---|---|
| kb_document_type *(required)* | string Enum: kb_offer kb_order kb_invoice | The type of the document. Text positions can be added to quotes, orders and invoices |
| document_id *(required)* | integer <int32> | the id of the document. E.g. if the `kb_document_type` is set to `kb_invoice` the `document_id` must be set to the ID of the invoice |
| position_id *(required)* | integer <int32> | the id of the position |

### Request Body schema: application/json

| Parameter | Type | Description |
|---|---|---|
| text | string |  |
| show_pos_nr | boolean |  |

### Responses

200, 422

**200** — OK

**Response samples** (200):

```json
{
  "id": 1,
  "text": "This position type allows to add free text to a document",
  "show_pos_nr": false,
  "pos": null,
  "internal_pos": 1,
  "is_optional": false,
  "type": "KbPositionText",
  "parent_id": null
}
```

**422** — Validation error

**Request sample**:

```json
{
  "text": "This position type allows to add free text to a document",
  "show_pos_nr": false
}
```

---

## `DELETE` `/2.0/{kb_document_type}/{document_id}/kb_position_text/{position_id}` — Delete a text position

operationId: `v2DeleteTextPosition`

This action permanently deletes a text position for a document. It cannot be undone.
If you have an invoice with ID 4 you should replace the path parameter `kb_document_type` with kb_invoice and replace the path parameter `document_id` with `4`.

### path Parameters

| Parameter | Type | Description |
|---|---|---|
| kb_document_type *(required)* | string Enum: kb_offer kb_order kb_invoice | The type of the document. Text positions can be added to quotes, orders and invoices |
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
