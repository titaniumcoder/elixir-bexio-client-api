# Discount positions

Part of **Sales Order Management**. Extracted from docs.bexio.com (snapshot Mon, 28 Sep 2026 12:05:15 GMT). 5 operations.

| Method | Path | Title |
|---|---|---|
| `GET` | `/2.0/{kb_document_type}/{document_id}/kb_position_discount` | Fetch a list of discount positions |
| `POST` | `/2.0/{kb_document_type}/{document_id}/kb_position_discount` | Create a discount position |
| `GET` | `/2.0/{kb_document_type}/{document_id}/kb_position_discount/{position_id}` | Fetch a discount position |
| `POST` | `/2.0/{kb_document_type}/{document_id}/kb_position_discount/{position_id}` | Edit a discount position |
| `DELETE` | `/2.0/{kb_document_type}/{document_id}/kb_position_discount/{position_id}` | Delete a discount position |

## `GET` `/2.0/{kb_document_type}/{document_id}/kb_position_discount` — Fetch a list of discount positions

operationId: `v2ListDiscountPositions`

This action fetches a list of all discount positions for a document.
If you have an invoice with ID 4 you should replace the path parameter `kb_document_type` with kb_invoice and replace the path parameter `document_id` with `4`.

### path Parameters

| Parameter | Type | Description |
|---|---|---|
| kb_document_type *(required)* | string Enum: kb_offer kb_order kb_invoice | The type of the document. Discount positions can be added to quotes, orders and invoices |
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
    "text": "Partner discount",
    "is_percentual": true,
    "value": "10.000000",
    "discount_total": "1.780000",
    "type": "KbPositionDiscount"
  }
]
```

---

## `POST` `/2.0/{kb_document_type}/{document_id}/kb_position_discount` — Create a discount position

operationId: `v2CreateDiscountPosition`

This action creates a new discount position for a document
If you have an invoice with ID 4 you should replace the path parameter `kb_document_type` with kb_invoice and replace the path parameter `document_id` with `4`.

### path Parameters

| Parameter | Type | Description |
|---|---|---|
| kb_document_type *(required)* | string Enum: kb_offer kb_order kb_invoice | The type of the document. Discount positions can be added to quotes, orders and invoices |
| document_id *(required)* | integer <int32> | the id of the document. E.g. if the `kb_document_type` is set to `kb_invoice` the `document_id` must be set to the ID of the invoice |

### Request Body schema: application/json *(required)*

| Parameter | Type | Description |
|---|---|---|
| text | string |  |
| is_percentual | boolean |  |
| value | string |  |

### Responses

201, 422

**201** — Created

**Response samples** (201):

```json
{
  "id": 1,
  "text": "Partner discount",
  "is_percentual": true,
  "value": "10.000000",
  "discount_total": "1.780000",
  "type": "KbPositionDiscount"
}
```

**422** — Validation error

**Request sample**:

```json
{
  "text": "Partner discount",
  "is_percentual": true,
  "value": "10.000000"
}
```

---

## `GET` `/2.0/{kb_document_type}/{document_id}/kb_position_discount/{position_id}` — Fetch a discount position

operationId: `v2ShowDiscountPosition`

This action fetches a single discount position for a document.
If you have an invoice with ID 4 you should replace the path parameter `kb_document_type` with kb_invoice and replace the path parameter `document_id` with `4`.

### path Parameters

| Parameter | Type | Description |
|---|---|---|
| kb_document_type *(required)* | string Enum: kb_offer kb_order kb_invoice | The type of the document. Discount positions can be added to quotes, orders and invoices |
| document_id *(required)* | integer <int32> | the id of the document. E.g. if the `kb_document_type` is set to `kb_invoice` the `document_id` must be set to the ID of the invoice |
| position_id *(required)* | integer <int32> | the id of the position |

### Responses

200

**200** — OK

**Response samples** (200):

```json
{
  "id": 1,
  "text": "Partner discount",
  "is_percentual": true,
  "value": "10.000000",
  "discount_total": "1.780000",
  "type": "KbPositionDiscount"
}
```

---

## `POST` `/2.0/{kb_document_type}/{document_id}/kb_position_discount/{position_id}` — Edit a discount position

operationId: `v2EditDiscountPosition`

This action edits a single discount position for a document
If you have an invoice with ID 4 you should replace the path parameter `kb_document_type` with kb_invoice and replace the path parameter `document_id` with `4`.

### path Parameters

| Parameter | Type | Description |
|---|---|---|
| kb_document_type *(required)* | string Enum: kb_offer kb_order kb_invoice | The type of the document. Discount positions can be added to quotes, orders and invoices |
| document_id *(required)* | integer <int32> | the id of the document. E.g. if the `kb_document_type` is set to `kb_invoice` the `document_id` must be set to the ID of the invoice |
| position_id *(required)* | integer <int32> | the id of the position |

### Request Body schema: application/json

| Parameter | Type | Description |
|---|---|---|
| text | string |  |
| is_percentual | boolean |  |
| value | string |  |

### Responses

200, 422

**200** — OK

**Response samples** (200):

```json
{
  "id": 1,
  "text": "Partner discount",
  "is_percentual": true,
  "value": "10.000000",
  "discount_total": "1.780000",
  "type": "KbPositionDiscount"
}
```

**422** — Validation error

**Request sample**:

```json
{
  "text": "Partner discount",
  "is_percentual": true,
  "value": "10.000000"
}
```

---

## `DELETE` `/2.0/{kb_document_type}/{document_id}/kb_position_discount/{position_id}` — Delete a discount position

operationId: `v2DeleteDiscountPosition`

This action permanently deletes a discount position for a document. It cannot be undone.
If you have an invoice with ID 4 you should replace the path parameter `kb_document_type` with kb_invoice and replace the path parameter `document_id` with `4`.

### path Parameters

| Parameter | Type | Description |
|---|---|---|
| kb_document_type *(required)* | string Enum: kb_offer kb_order kb_invoice | The type of the document. Discount positions can be added to quotes, orders and invoices |
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
