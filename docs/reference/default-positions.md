# Default positions

Part of **Sales Order Management**. Extracted from docs.bexio.com (snapshot Mon, 28 Sep 2026 12:05:15 GMT). 5 operations.

| Method | Path | Title |
|---|---|---|
| `GET` | `/2.0/{kb_document_type}/{document_id}/kb_position_custom` | Fetch a list of default positions |
| `POST` | `/2.0/{kb_document_type}/{document_id}/kb_position_custom` | Create a default position |
| `GET` | `/2.0/{kb_document_type}/{document_id}/kb_position_custom/{position_id}` | Fetch a default position |
| `POST` | `/2.0/{kb_document_type}/{document_id}/kb_position_custom/{position_id}` | Edit a default position |
| `DELETE` | `/2.0/{kb_document_type}/{document_id}/kb_position_custom/{position_id}` | Delete a default position |

## `GET` `/2.0/{kb_document_type}/{document_id}/kb_position_custom` — Fetch a list of default positions

operationId: `v2ListDefaultPositions`

This action fetches a list of all default positions for a document.
If you have an invoice with ID 4 you should replace the path parameter `kb_document_type` with kb_invoice and replace the path parameter `document_id` with `4`.

### path Parameters

| Parameter | Type | Description |
|---|---|---|
| kb_document_type *(required)* | string Enum: kb_offer kb_order kb_invoice | The type of the document. Default positions can be added to quotes, orders and invoices |
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
    "amount": "5.000000",
    "amount_reserved": "5.000000",
    "amount_open": "5.000000",
    "amount_completed": "5.000000",
    "unit_id": 1,
    "account_id": 1,
    "unit_name": "kg",
    "tax_id": 4,
    "tax_value": "7.70",
    "text": "Apples",
    "unit_price": "3.560000",
    "discount_in_percent": "0.000000",
    "position_total": "17.800000",
    "pos": 1,
    "internal_pos": 1,
    "is_optional": false,
    "type": "KbPositionCustom",
    "parent_id": null
  }
]
```

---

## `POST` `/2.0/{kb_document_type}/{document_id}/kb_position_custom` — Create a default position

operationId: `v2CreateDefaultPosition`

This action creates a new default position for a document
If you have an invoice with ID 4 you should replace the path parameter `kb_document_type` with kb_invoice and replace the path parameter `document_id` with `4`.

### path Parameters

| Parameter | Type | Description |
|---|---|---|
| kb_document_type *(required)* | string Enum: kb_offer kb_order kb_invoice | The type of the document. Default positions can be added to quotes, orders and invoices |
| document_id *(required)* | integer <int32> | the id of the document. E.g. if the `kb_document_type` is set to `kb_invoice` the `document_id` must be set to the ID of the invoice |

### Request Body schema: application/json *(required)*

| Parameter | Type | Description |
|---|---|---|
| amount | string |  |
| amount_reserved | string |  |
| amount_open | string |  |
| amount_completed | string |  |
| unit_id | integer | References a unit object |
| account_id | integer | References an account object |
| tax_id | integer | References a tax object Please note that only active sales taxes can be used as references on the document types `quote`, `order` and `invoice`. An easy way to retrieve all valid taxes is by calling the taxes endpoint with the query parameters `types=sales_tax&scope=active` (this would result in the path `/3.0/taxes?types=sales_tax&scope=active`). |
| text | string |  |
| unit_price | string | The price of one unit (max. 6 decimals) |
| discount_in_percent | string or null | The discount (max. 6 decimals) |
| is_optional | boolean | Only in the case of quotes or Orders |

### Responses

201, 422

**201** — Created

**Response samples** (201):

```json
{
  "id": 1,
  "amount": "5.000000",
  "amount_reserved": "5.000000",
  "amount_open": "5.000000",
  "amount_completed": "5.000000",
  "unit_id": 1,
  "account_id": 1,
  "unit_name": "kg",
  "tax_id": 4,
  "tax_value": "7.70",
  "text": "Apples",
  "unit_price": "3.560000",
  "discount_in_percent": "0.000000",
  "position_total": "17.800000",
  "pos": 1,
  "internal_pos": 1,
  "is_optional": null,
  "type": "KbPositionCustom",
  "parent_id": null
}
```

**422** — Validation error

**Request sample**:

```json
{
  "amount": "5.000000",
  "amount_reserved": "5.000000",
  "amount_open": "5.000000",
  "amount_completed": "5.000000",
  "unit_id": 1,
  "account_id": 1,
  "tax_id": 4,
  "text": "Apples",
  "unit_price": "3.560000",
  "discount_in_percent": "0.000000",
  "is_optional": false
}
```

---

## `GET` `/2.0/{kb_document_type}/{document_id}/kb_position_custom/{position_id}` — Fetch a default position

operationId: `v2ShowDefaultPosition`

This action fetches a single default position for a document.
If you have an invoice with ID 4 you should replace the path parameter `kb_document_type` with kb_invoice and replace the path parameter `document_id` with `4`.

### path Parameters

| Parameter | Type | Description |
|---|---|---|
| kb_document_type *(required)* | string Enum: kb_offer kb_order kb_invoice | The type of the document. Default positions can be added to quotes, orders and invoices |
| document_id *(required)* | integer <int32> | the id of the document. E.g. if the `kb_document_type` is set to `kb_invoice` the `document_id` must be set to the ID of the invoice |
| position_id *(required)* | integer <int32> | the id of the position |

### Responses

200

**200** — OK

**Response samples** (200):

```json
{
  "id": 1,
  "amount": "5.000000",
  "amount_reserved": "5.000000",
  "amount_open": "5.000000",
  "amount_completed": "5.000000",
  "unit_id": 1,
  "account_id": 1,
  "unit_name": "kg",
  "tax_id": 4,
  "tax_value": "7.70",
  "text": "Apples",
  "unit_price": "3.560000",
  "discount_in_percent": "0.000000",
  "position_total": "17.800000",
  "pos": 1,
  "internal_pos": 1,
  "is_optional": false,
  "type": "KbPositionCustom",
  "parent_id": null
}
```

---

## `POST` `/2.0/{kb_document_type}/{document_id}/kb_position_custom/{position_id}` — Edit a default position

operationId: `v2EditDefaultPosition`

This action edits a single default position for a document
If you have an invoice with ID 4 you should replace the path parameter `kb_document_type` with kb_invoice and replace the path parameter `document_id` with `4`.

### path Parameters

| Parameter | Type | Description |
|---|---|---|
| kb_document_type *(required)* | string Enum: kb_offer kb_order kb_invoice | The type of the document. Default positions can be added to quotes, orders and invoices |
| document_id *(required)* | integer <int32> | the id of the document. E.g. if the `kb_document_type` is set to `kb_invoice` the `document_id` must be set to the ID of the invoice |
| position_id *(required)* | integer <int32> | the id of the position |

### Request Body schema: application/json

| Parameter | Type | Description |
|---|---|---|
| amount | string |  |
| amount_reserved | string |  |
| amount_open | string |  |
| amount_completed | string |  |
| unit_id | integer | References a unit object |
| account_id | integer | References an account object |
| tax_id | integer | References a tax object Please note that only active sales taxes can be used as references on the document types `quote`, `order` and `invoice`. An easy way to retrieve all valid taxes is by calling the taxes endpoint with the query parameters `types=sales_tax&scope=active` (this would result in the path `/3.0/taxes?types=sales_tax&scope=active`). |
| text | string |  |
| unit_price | string | The price of one unit (max. 6 decimals) |
| discount_in_percent | string or null | The discount (max. 6 decimals) |
| is_optional | boolean | Only in the case of quotes or Orders |

### Responses

200, 422

**200** — OK

**Response samples** (200):

```json
{
  "id": 1,
  "amount": "5.000000",
  "amount_reserved": "5.000000",
  "amount_open": "5.000000",
  "amount_completed": "5.000000",
  "unit_id": 1,
  "account_id": 1,
  "unit_name": "kg",
  "tax_id": 4,
  "tax_value": "7.70",
  "text": "Apples",
  "unit_price": "3.560000",
  "discount_in_percent": "0.000000",
  "position_total": "17.800000",
  "pos": 1,
  "internal_pos": 1,
  "is_optional": null,
  "type": "KbPositionCustom",
  "parent_id": null
}
```

**422** — Validation error

**Request sample**:

```json
{
  "amount": "5.000000",
  "amount_reserved": "5.000000",
  "amount_open": "5.000000",
  "amount_completed": "5.000000",
  "unit_id": 1,
  "account_id": 1,
  "tax_id": 4,
  "text": "Apples",
  "unit_price": "3.560000",
  "discount_in_percent": "0.000000",
  "is_optional": false
}
```

---

## `DELETE` `/2.0/{kb_document_type}/{document_id}/kb_position_custom/{position_id}` — Delete a default position

operationId: `v2DeleteDefaultPosition`

This action permanently deletes a default position for a document. It cannot be undone.
If you have an invoice with ID 4 you should replace the path parameter `kb_document_type` with kb_invoice and replace the path parameter `document_id` with `4`.

### path Parameters

| Parameter | Type | Description |
|---|---|---|
| kb_document_type *(required)* | string Enum: kb_offer kb_order kb_invoice | The type of the document. Default positions can be added to quotes, orders and invoices |
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
