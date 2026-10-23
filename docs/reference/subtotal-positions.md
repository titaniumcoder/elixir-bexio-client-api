# Subtotal positions

Part of **Sales Order Management**. Extracted from docs.bexio.com (snapshot Mon, 28 Sep 2026 12:05:15 GMT). 5 operations.

| Method | Path | Title |
|---|---|---|
| `GET` | `/2.0/{kb_document_type}/{document_id}/kb_position_subtotal` | Fetch a list of subtotal positions |
| `POST` | `/2.0/{kb_document_type}/{document_id}/kb_position_subtotal` | Create a subtotal position |
| `GET` | `/2.0/{kb_document_type}/{document_id}/kb_position_subtotal/{position_id}` | Fetch a subtotal position |
| `POST` | `/2.0/{kb_document_type}/{document_id}/kb_position_subtotal/{position_id}` | Edit a subtotal position |
| `DELETE` | `/2.0/{kb_document_type}/{document_id}/kb_position_subtotal/{position_id}` | Delete a subtotal position |

## `GET` `/2.0/{kb_document_type}/{document_id}/kb_position_subtotal` — Fetch a list of subtotal positions

operationId: `v2ListSubtotalPositions`

This action fetches a list of all subtotal positions for a document.
If you have an invoice with ID 4 you should replace the path parameter `kb_document_type` with kb_invoice and replace the path parameter `document_id` with `4`.

### path Parameters

| Parameter | Type | Description |
|---|---|---|
| kb_document_type *(required)* | string Enum: kb_offer kb_order kb_invoice | The type of the document. Subtotal positions can be added to quotes, orders and invoices |
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
    "text": "Subtotal",
    "value": "17.800000",
    "internal_pos": 1,
    "is_optional": false,
    "type": "KbPositionSubtotal",
    "parent_id": null
  }
]
```

---

## `POST` `/2.0/{kb_document_type}/{document_id}/kb_position_subtotal` — Create a subtotal position

operationId: `v2CreateSubtotalPosition`

This action creates a new subtotal position for a document
If you have an invoice with ID 4 you should replace the path parameter `kb_document_type` with kb_invoice and replace the path parameter `document_id` with `4`.

### path Parameters

| Parameter | Type | Description |
|---|---|---|
| kb_document_type *(required)* | string Enum: kb_offer kb_order kb_invoice | The type of the document. Subtotal positions can be added to quotes, orders and invoices |
| document_id *(required)* | integer <int32> | the id of the document. E.g. if the `kb_document_type` is set to `kb_invoice` the `document_id` must be set to the ID of the invoice |

### Request Body schema: application/json *(required)*

| Parameter | Type | Description |
|---|---|---|
| text | string |  |

### Responses

201, 422

**201** — Created

**Response samples** (201):

```json
{
  "id": 1,
  "text": "Subtotal",
  "value": "17.800000",
  "internal_pos": 1,
  "is_optional": false,
  "type": "KbPositionSubtotal",
  "parent_id": null
}
```

**422** — Validation error

**Request sample**:

```json
{
  "text": "Subtotal"
}
```

---

## `GET` `/2.0/{kb_document_type}/{document_id}/kb_position_subtotal/{position_id}` — Fetch a subtotal position

operationId: `v2ShowSubtotalPosition`

This action fetches a single subtotal position for a document.
If you have an invoice with ID 4 you should replace the path parameter `kb_document_type` with kb_invoice and replace the path parameter `document_id` with `4`.

### path Parameters

| Parameter | Type | Description |
|---|---|---|
| kb_document_type *(required)* | string Enum: kb_offer kb_order kb_invoice | The type of the document. Subtotal positions can be added to quotes, orders and invoices |
| document_id *(required)* | integer <int32> | the id of the document. E.g. if the `kb_document_type` is set to `kb_invoice` the `document_id` must be set to the ID of the invoice |
| position_id *(required)* | integer <int32> | the id of the position |

### Responses

200

**200** — OK

**Response samples** (200):

```json
{
  "id": 1,
  "text": "Subtotal",
  "value": "17.800000",
  "internal_pos": 1,
  "is_optional": false,
  "type": "KbPositionSubtotal",
  "parent_id": null
}
```

---

## `POST` `/2.0/{kb_document_type}/{document_id}/kb_position_subtotal/{position_id}` — Edit a subtotal position

operationId: `v2EditSubtotalPosition`

This action edits a single subtotal position for a document
If you have an invoice with ID 4 you should replace the path parameter `kb_document_type` with kb_invoice and replace the path parameter `document_id` with `4`.

### path Parameters

| Parameter | Type | Description |
|---|---|---|
| kb_document_type *(required)* | string Enum: kb_offer kb_order kb_invoice | The type of the document. Subtotal positions can be added to quotes, orders and invoices |
| document_id *(required)* | integer <int32> | the id of the document. E.g. if the `kb_document_type` is set to `kb_invoice` the `document_id` must be set to the ID of the invoice |
| position_id *(required)* | integer <int32> | the id of the position |

### Request Body schema: application/json

| Parameter | Type | Description |
|---|---|---|
| text | string |  |

### Responses

200, 422

**200** — OK

**Response samples** (200):

```json
{
  "id": 1,
  "text": "Subtotal",
  "value": "17.800000",
  "internal_pos": 1,
  "is_optional": false,
  "type": "KbPositionSubtotal",
  "parent_id": null
}
```

**422** — Validation error

**Request sample**:

```json
{
  "text": "Subtotal"
}
```

---

## `DELETE` `/2.0/{kb_document_type}/{document_id}/kb_position_subtotal/{position_id}` — Delete a subtotal position

operationId: `v2DeleteSubtotalPosition`

This action permanently deletes a subtotal position for a document. It cannot be undone.
If you have an invoice with ID 4 you should replace the path parameter `kb_document_type` with kb_invoice and replace the path parameter `document_id` with `4`.

### path Parameters

| Parameter | Type | Description |
|---|---|---|
| kb_document_type *(required)* | string Enum: kb_offer kb_order kb_invoice | The type of the document. Subtotal positions can be added to quotes, orders and invoices |
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
