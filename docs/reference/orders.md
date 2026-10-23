# Orders

Part of **Sales Order Management**. Extracted from docs.bexio.com (snapshot Mon, 28 Sep 2026 12:05:15 GMT). 12 operations.

| Method | Path | Title |
|---|---|---|
| `GET` | `/2.0/kb_order` | Fetch a list of orders |
| `POST` | `/2.0/kb_order` | Create order |
| `POST` | `/2.0/kb_order/search` | Search orders |
| `GET` | `/2.0/kb_order/{order_id}` | Fetch an order |
| `POST` | `/2.0/kb_order/{order_id}` | Edit an order |
| `DELETE` | `/2.0/kb_order/{order_id}` | Delete an order |
| `POST` | `/2.0/kb_order/{order_id}/delivery` | Create delivery from order |
| `POST` | `/2.0/kb_order/{order_id}/invoice` | Create invoice from order |
| `GET` | `/2.0/kb_order/{order_id}/pdf` | Show PDF |
| `GET` | `/2.0/kb_order/{order_id}/repetition` | Show repetition |
| `POST` | `/2.0/kb_order/{order_id}/repetition` | Edit a repetition |
| `DELETE` | `/2.0/kb_order/{order_id}/repetition` | Delete a repetition |

## `GET` `/2.0/kb_order` — Fetch a list of orders

operationId: `v2ListOrders`

This action fetches a list of all orders

### query Parameters

| Parameter | Type | Description |
|---|---|---|
| order_by | string Default: id Enum: id total total_net total_gross updated_at | Defines the order of the results. Multiple sort parameters can be combined by using a comma separator. `_asc` and `_desc` can be appended to any parameter to either sort ascending (default) or descending. |
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
    "document_nr": "AU-00001",
    "title": null,
    "contact_id": 14,
    "contact_sub_id": null,
    "user_id": 1,
    "project_id": null,
    "logopaper_id": 1,
    "language_id": 1,
    "bank_account_id": 1,
    "currency_id": 1,
    "payment_type_id": 1,
    "header": "Thank you very much for your inquiry. We would be pleased to make you the following offer:",
    "footer": "We hope that our offer meets your expectations and will be happy to answer your questions.",
    "total_gross": "17.800000",
    "total_net": "17.800000",
    "total_taxes": "1.3706",
    "total": "19.150000",
    "total_rounding_difference": -0.02,
    "mwst_type": 0,
    "mwst_is_net": true,
    "show_position_taxes": false,
    "is_valid_from": "2019-06-24",
    "contact_address": "Muster AG\nMusterstrasse 15\n8640 Rapperswil",
    "delivery_address_type": 0,
    "delivery_address": "Muster AG\nMusterstrasse 15\n8640 Rapperswil",
    "kb_item_status_id": 5,
    "is_recurring": false,
    "api_reference": null,
    "viewed_by_client_at": null,
    "updated_at": "2019-04-08 13:17:32",
    "template_slug": "581a8010821e01426b8b456b",
    "taxs": [
      {
        "percentage": "7.70",
        "value": "1.3706"
      }
    ],
    "network_link": ""
  }
]
```

---

## `POST` `/2.0/kb_order` — Create order

operationId: `v2CreateOrder`

This action creates a new order

### Request Body schema: application/json *(required)*

| Parameter | Type | Description |
|---|---|---|
| document_nr | string | Can not be used if “automatic numbering” is activated in frontend-settings. Required if “automatic numbering” deactivated. https://help.bexio.com/s/article/000001784 |
| title | string or null |  |
| contact_id | integer | References a contact object |
| contact_sub_id | integer or null | References a contact object |
| user_id | integer | References a user object |
| pr_project_id | integer or null | References a project object |
| logopaper_id *(deprecated)* | integer |  |
| language_id | integer | References a language object |
| bank_account_id | integer | References a bank account object |
| currency_id | integer | References a currency object |
| payment_type_id | integer | References a payment type object |
| header | string |  |
| footer | string |  |
| mwst_type | integer Enum: 0 1 2 | value description 0 including taxes 1 excluding taxes 2 exempt from taxes |
| mwst_is_net | boolean | This value affects the total if the field `mwst_type` has been set to 0. `false` = Taxes are included in the total `true` = Taxes will be added to the total |
| show_position_taxes | boolean |  |
| is_valid_from | string <date> |  |
| contact_address_manual | string or null | This field can be used to set a contact address manually. If not in use or `null` the invoice address of the contact will be taken. |
| delivery_address_type | integer Enum: 0 1 | value description 0 use invoice address 1 use custom address |
| delivery_address_manual | string or null | This field can be used to set a delivery address manually if `delivery_address_type` is set to `1`. If not in use or `null` the invoice address will be taken. |
| api_reference | string or null | This field can only be read and edited by the api. It can be used to save references to other systems. |
| template_slug | string or null | References a document template slug |
| positions | array | Please note that you can combine multiple positions. This means that an array containing `KbPositionCustom` and `KbPositionArticle` positions is valid. Recommendation: use a maximum of 150 positions when creating sales documents. Other positions can be added using the item creation endpoint. |

### Responses

201, 422

**201** — Created

**Response samples** (201):

```json
{
  "id": 4,
  "document_nr": "AU-00001",
  "title": null,
  "contact_id": 14,
  "contact_sub_id": null,
  "user_id": 1,
  "project_id": null,
  "logopaper_id": 1,
  "language_id": 1,
  "bank_account_id": 1,
  "currency_id": 1,
  "payment_type_id": 1,
  "header": "Thank you very much for your inquiry. We would be pleased to make you the following offer:",
  "footer": "We hope that our offer meets your expectations and will be happy to answer your questions.",
  "total_gross": "17.800000",
  "total_net": "17.800000",
  "total_taxes": "1.3706",
  "total": "19.150000",
  "total_rounding_difference": -0.02,
  "mwst_type": 0,
  "mwst_is_net": true,
  "show_position_taxes": false,
  "is_valid_from": "2019-06-24",
  "contact_address": "Muster AG\nMusterstrasse 15\n8640 Rapperswil",
  "delivery_address_type": 0,
  "delivery_address": "Muster AG\nMusterstrasse 15\n8640 Rapperswil",
  "kb_item_status_id": 5,
  "is_recurring": false,
  "api_reference": null,
  "viewed_by_client_at": null,
  "updated_at": "2019-04-08 13:17:32",
  "template_slug": "581a8010821e01426b8b456b",
  "taxs": [
    {
      "percentage": "7.70",
      "value": "1.3706"
    }
  ],
  "network_link": "",
  "positions": [
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
  ]
}
```

**422** — Validation error

**Request sample**:

```json
{
  "document_nr": "AU-00001",
  "title": null,
  "contact_id": 14,
  "contact_sub_id": null,
  "user_id": 1,
  "pr_project_id": null,
  "logopaper_id": 1,
  "language_id": 1,
  "bank_account_id": 1,
  "currency_id": 1,
  "payment_type_id": 1,
  "header": "Thank you very much for your inquiry. We would be pleased to make you the following offer:",
  "footer": "We hope that our offer meets your expectations and will be happy to answer your questions.",
  "mwst_type": 0,
  "mwst_is_net": true,
  "show_position_taxes": false,
  "is_valid_from": "2019-06-24",
  "contact_address_manual": "UTA Immobilien AG\nStadtturmstrasse 15\n5400 Baden",
  "delivery_address_type": 0,
  "delivery_address_manual": "UTA Immobilien AG\nStadtturmstrasse 15\n5400 Baden",
  "api_reference": null,
  "template_slug": "581a8010821e01426b8b456b",
  "positions": [
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
      "is_optional": null,
      "type": "KbPositionCustom",
      "parent_id": null
    }
  ]
}
```

---

## `POST` `/2.0/kb_order/search` — Search orders

operationId: `v2SearchOrders`

Search orders via query. Please refer to the Search section for detailed instructions.
The following search fields are supported:
- `id`
- `kb_item_status_id`
- `document_nr`
- `title`
- `contact_id`
- `contact_sub_id`
- `user_id`
- `currency_id`
- `total_gross`
- `total_net`
- `total`
- `is_valid_from`
- `is_valid_to`
- `updated_at`

### query Parameters

| Parameter | Type | Description |
|---|---|---|
| order_by | string Default: id Enum: id total total_net total_gross updated_at | Defines the order of the results. Multiple sort parameters can be combined by using a comma separator. `_asc` and `_desc` can be appended to any parameter to either sort ascending (default) or descending. |
| limit | integer <int32> Default: 500 | Limit the number of results (max is 2000) |
| offset | integer <int32> Default: 0 | Skip over a number of elements by specifying an offset value for the query |

### Request Body schema: application/json *(required)*

| Parameter | Type | Description |
|---|---|---|
| field *(required)* | string | Field which should be search over |
| value *(required)* | string | Value to search for |
| criteria | string Default: like Enum: = equal != not_equal > greater_than >= greater_equal < less_than <= less_equal like not_like is_null not_null in not_in |  |

### Responses

200, 422

**200** — OK

**Response samples** (200):

```json
[
  {
    "id": 4,
    "document_nr": "AU-00001",
    "title": null,
    "contact_id": 14,
    "contact_sub_id": null,
    "user_id": 1,
    "project_id": null,
    "logopaper_id": 1,
    "language_id": 1,
    "bank_account_id": 1,
    "currency_id": 1,
    "payment_type_id": 1,
    "header": "Thank you very much for your inquiry. We would be pleased to make you the following offer:",
    "footer": "We hope that our offer meets your expectations and will be happy to answer your questions.",
    "total_gross": "17.800000",
    "total_net": "17.800000",
    "total_taxes": "1.3706",
    "total": "19.150000",
    "total_rounding_difference": -0.02,
    "mwst_type": 0,
    "mwst_is_net": true,
    "show_position_taxes": false,
    "is_valid_from": "2019-06-24",
    "contact_address": "Muster AG\nMusterstrasse 15\n8640 Rapperswil",
    "delivery_address_type": 0,
    "delivery_address": "Muster AG\nMusterstrasse 15\n8640 Rapperswil",
    "kb_item_status_id": 5,
    "is_recurring": false,
    "api_reference": null,
    "viewed_by_client_at": null,
    "updated_at": "2019-04-08 13:17:32",
    "template_slug": "581a8010821e01426b8b456b",
    "taxs": [
      {
        "percentage": "7.70",
        "value": "1.3706"
      }
    ],
    "network_link": ""
  }
]
```

**422** — Validation error

**Request sample**:

```json
[
  {
    "field": "search_field",
    "value": "search term",
    "criteria": "="
  }
]
```

---

## `GET` `/2.0/kb_order/{order_id}` — Fetch an order

operationId: `v2ShowOrder`

This action fetches a single order

### path Parameters

| Parameter | Type | Description |
|---|---|---|
| order_id *(required)* | integer <int32> | the id of the order |

### Responses

200

**200** — OK

**Response samples** (200):

```json
{
  "id": 4,
  "document_nr": "AU-00001",
  "title": null,
  "contact_id": 14,
  "contact_sub_id": null,
  "user_id": 1,
  "project_id": null,
  "logopaper_id": 1,
  "language_id": 1,
  "bank_account_id": 1,
  "currency_id": 1,
  "payment_type_id": 1,
  "header": "Thank you very much for your inquiry. We would be pleased to make you the following offer:",
  "footer": "We hope that our offer meets your expectations and will be happy to answer your questions.",
  "total_gross": "17.800000",
  "total_net": "17.800000",
  "total_taxes": "1.3706",
  "total": "19.150000",
  "total_rounding_difference": -0.02,
  "mwst_type": 0,
  "mwst_is_net": true,
  "show_position_taxes": false,
  "is_valid_from": "2019-06-24",
  "contact_address": "Muster AG\nMusterstrasse 15\n8640 Rapperswil",
  "delivery_address_type": 0,
  "delivery_address": "Muster AG\nMusterstrasse 15\n8640 Rapperswil",
  "kb_item_status_id": 5,
  "is_recurring": false,
  "api_reference": null,
  "viewed_by_client_at": null,
  "updated_at": "2019-04-08 13:17:32",
  "template_slug": "581a8010821e01426b8b456b",
  "taxs": [
    {
      "percentage": "7.70",
      "value": "1.3706"
    }
  ],
  "network_link": "",
  "positions": [
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
  ]
}
```

---

## `POST` `/2.0/kb_order/{order_id}` — Edit an order

operationId: `v2EditOrder`

This action edits a single order

### path Parameters

| Parameter | Type | Description |
|---|---|---|
| order_id *(required)* | integer <int32> | the id of the order |

### Request Body schema: application/json

| Parameter | Type | Description |
|---|---|---|
| document_nr | string | Can not be used if “automatic numbering” is activated in frontend-settings. Required if “automatic numbering” deactivated. https://help.bexio.com/s/article/000001784 |
| title | string or null |  |
| contact_id | integer or null | References a contact object |
| contact_sub_id | integer or null | References a contact object |
| user_id | integer | References a user object |
| pr_project_id | integer or null | References a project object |
| logopaper_id *(deprecated)* | integer |  |
| language_id | integer | References a language object |
| bank_account_id | integer | References a bank account object |
| currency_id | integer | References a currency object |
| payment_type_id | integer | References a payment type object |
| header | string |  |
| footer | string |  |
| mwst_type | integer Enum: 0 1 2 | value description 0 including taxes 1 excluding taxes 2 exempt from taxes |
| mwst_is_net | boolean | This value affects the total if the field `mwst_type` has been set to 0. `false` = Taxes are included in the total `true` = Taxes will be added to the total |
| show_position_taxes | boolean |  |
| is_valid_from | string <date> |  |
| contact_address_manual | string or null | This field can be used to set a contact address manually. If not in use or `null` the invoice address of the contact will be taken. |
| delivery_address_type | integer Enum: 0 1 | value description 0 use invoice address 1 use custom address |
| delivery_address_manual | string or null | This field can be used to set a delivery address manually if `delivery_address_type` is set to `1`. If not in use or `null` the invoice address will be taken. |
| api_reference | string or null | This field can only be read and edited by the api. It can be used to save references to other systems. |
| template_slug | string or null | References a document template slug |

### Responses

200, 422

**200** — OK

**Response samples** (200):

```json
{
  "id": 4,
  "document_nr": "AU-00001",
  "title": null,
  "contact_id": 14,
  "contact_sub_id": null,
  "user_id": 1,
  "project_id": null,
  "logopaper_id": 1,
  "language_id": 1,
  "bank_account_id": 1,
  "currency_id": 1,
  "payment_type_id": 1,
  "header": "Thank you very much for your inquiry. We would be pleased to make you the following offer:",
  "footer": "We hope that our offer meets your expectations and will be happy to answer your questions.",
  "total_gross": "17.800000",
  "total_net": "17.800000",
  "total_taxes": "1.3706",
  "total": "19.150000",
  "total_rounding_difference": -0.02,
  "mwst_type": 0,
  "mwst_is_net": true,
  "show_position_taxes": false,
  "is_valid_from": "2019-06-24",
  "contact_address": "Muster AG\nMusterstrasse 15\n8640 Rapperswil",
  "delivery_address_type": 0,
  "delivery_address": "Muster AG\nMusterstrasse 15\n8640 Rapperswil",
  "kb_item_status_id": 5,
  "is_recurring": false,
  "api_reference": null,
  "viewed_by_client_at": null,
  "updated_at": "2019-04-08 13:17:32",
  "template_slug": "581a8010821e01426b8b456b",
  "taxs": [
    {
      "percentage": "7.70",
      "value": "1.3706"
    }
  ],
  "network_link": "",
  "positions": [
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
  ]
}
```

**422** — Validation error

**Request sample**:

```json
{
  "document_nr": "AU-00001",
  "title": null,
  "contact_id": 14,
  "contact_sub_id": null,
  "user_id": 1,
  "pr_project_id": null,
  "logopaper_id": 1,
  "language_id": 1,
  "bank_account_id": 1,
  "currency_id": 1,
  "payment_type_id": 1,
  "header": "Thank you very much for your inquiry. We would be pleased to make you the following offer:",
  "footer": "We hope that our offer meets your expectations and will be happy to answer your questions.",
  "mwst_type": 0,
  "mwst_is_net": true,
  "show_position_taxes": false,
  "is_valid_from": "2019-06-24",
  "contact_address_manual": "UTA Immobilien AG\nStadtturmstrasse 15\n5400 Baden",
  "delivery_address_type": 0,
  "delivery_address_manual": "UTA Immobilien AG\nStadtturmstrasse 15\n5400 Baden",
  "api_reference": null,
  "template_slug": "581a8010821e01426b8b456b"
}
```

---

## `DELETE` `/2.0/kb_order/{order_id}` — Delete an order

operationId: `DeleteOrder`

This action permanently deletes an order. It cannot be undone.

### path Parameters

| Parameter | Type | Description |
|---|---|---|
| order_id *(required)* | integer <int32> | the id of the order |

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

## `POST` `/2.0/kb_order/{order_id}/delivery` — Create delivery from order

operationId: `v2CreateDeliveryFromOrder`

This action creates a delivery from an order.

### path Parameters

| Parameter | Type | Description |
|---|---|---|
| order_id *(required)* | integer <int32> | the id of the order |

### Request Body schema: application/json

| Parameter | Type | Description |
|---|---|---|

### Responses

200, 422

**200** — OK

**Response samples** (200):

```json
{
  "id": 4,
  "document_nr": "LS-00001",
  "title": null,
  "contact_id": 14,
  "contact_sub_id": null,
  "user_id": 1,
  "logopaper_id": 1,
  "language_id": 1,
  "bank_account_id": 1,
  "currency_id": 1,
  "header": "Thank you very much for your inquiry.:",
  "footer": "We hope that our delivery meets your expectations and will be happy to answer your questions.",
  "total_gross": "17.800000",
  "total_net": "17.800000",
  "total_taxes": "1.3706",
  "total": "19.150000",
  "total_rounding_difference": -0.02,
  "mwst_type": 0,
  "mwst_is_net": true,
  "is_valid_from": "2019-06-24",
  "contact_address": "Muster AG\nMusterstrasse 15\n8640 Rapperswil",
  "delivery_address_type": 0,
  "delivery_address": "Muster AG\nMusterstrasse 15\n8640 Rapperswil",
  "kb_item_status_id": 10,
  "api_reference": null,
  "viewed_by_client_at": null,
  "updated_at": "2019-04-08 13:17:32",
  "taxs": [
    {
      "percentage": "7.70",
      "value": "1.3706"
    }
  ],
  "positions": [
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
  ]
}
```

**422** — Validation error

**Request sample**:

```json
{
  "positions": [
    {
      "id": 1,
      "type": "KbPositionArticle",
      "amount": 5
    }
  ]
}
```

---

## `POST` `/2.0/kb_order/{order_id}/invoice` — Create invoice from order

operationId: `v2CreateInvoiceFromOrder`

This action creates an invoice from an order.

### path Parameters

| Parameter | Type | Description |
|---|---|---|
| order_id *(required)* | integer <int32> | the id of the order |

### Request Body schema: application/json

| Parameter | Type | Description |
|---|---|---|

### Responses

200, 422

**200** — OK

**Response samples** (200):

```json
{
  "id": 4,
  "document_nr": "RE-00001",
  "title": null,
  "contact_id": 14,
  "contact_sub_id": null,
  "user_id": 1,
  "project_id": null,
  "logopaper_id": 1,
  "language_id": 1,
  "bank_account_id": 1,
  "currency_id": 1,
  "payment_type_id": 1,
  "header": "Thank you very much for your inquiry. We would be pleased to make you the following offer:",
  "footer": "We hope that our offer meets your expectations and will be happy to answer your questions.",
  "total_gross": "17.800000",
  "total_net": "17.800000",
  "total_taxes": "1.3706",
  "total_received_payments": "0.000000",
  "total_credit_vouchers": "0.000000",
  "total_remaining_payments": "19.150000",
  "total": "19.150000",
  "total_rounding_difference": -0.02,
  "mwst_type": 0,
  "mwst_is_net": true,
  "show_position_taxes": false,
  "is_valid_from": "2019-06-24",
  "is_valid_to": "2019-07-24",
  "contact_address": "Muster AG\nMusterstrasse 15\n8640 Rapperswil",
  "kb_item_status_id": 3,
  "reference": null,
  "api_reference": null,
  "viewed_by_client_at": null,
  "updated_at": "2019-04-08 13:17:32",
  "esr_id": 1,
  "qr_invoice_id": 1,
  "template_slug": "581a8010821e01426b8b456b",
  "taxs": [
    {
      "percentage": "7.70",
      "value": "1.3706"
    }
  ],
  "network_link": "",
  "positions": [
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
  ]
}
```

**422** — Validation error

**Request sample**:

```json
{
  "positions": [
    {
      "id": 1,
      "type": "KbPositionArticle",
      "amount": 5
    }
  ]
}
```

---

## `GET` `/2.0/kb_order/{order_id}/pdf` — Show PDF

operationId: `v2ShowOrderPDF`

This action returns a pdf document of the order.

### path Parameters

| Parameter | Type | Description |
|---|---|---|
| order_id *(required)* | integer <int32> | the id of the order |
| logopaper | integer <int32> Enum: 0 1 | Whether the PDF should be generated using the letterhead, or not. |

### Responses

200

**200** — OK

**Response samples** (200):

```json
{
  "name": "document-00005.pdf",
  "size": 9768,
  "mime": "application/pdf",
  "content": "R0lGODlhAQABAIAAAAUEBAAAACwAAAAAAQABAAACAkQBADs="
}
```

---

## `GET` `/2.0/kb_order/{order_id}/repetition` — Show repetition

operationId: `v2ShowOrderRepetition`

This action fetches an order repetition

### path Parameters

| Parameter | Type | Description |
|---|---|---|
| order_id *(required)* | integer <int32> | the id of the order |

### Responses

200

**200** — OK

**Response samples** (200):

```json
{
  "start": "2019-01-01",
  "end": "2019-12-31",
  "repetition": {
    "type": "daily",
    "interval": 1
  }
}
```

---

## `POST` `/2.0/kb_order/{order_id}/repetition` — Edit a repetition

operationId: `v2EditOrderRepetition`

This action edits an order repetition

### path Parameters

| Parameter | Type | Description |
|---|---|---|
| order_id *(required)* | integer <int32> | the id of the order |

### Request Body schema: application/json

| Parameter | Type | Description |
|---|---|---|
| start | string <date> |  |
| end | string <date> or null | Date until the repetition is supposed to run. If empty indefinite repetition is assumed. |
| repetition | object | Four different formats can be used to define the repetition. Either type `daily`, `weekly`, `monthly` or type `yearly`. |

### Responses

200, 422

**200** — OK

**Response samples** (200):

```json
{
  "start": "2019-01-01",
  "end": "2019-12-31",
  "repetition": {
    "type": "daily",
    "interval": 1
  }
}
```

**422** — Validation error

**Request sample**:

```json
{
  "start": "2019-01-01",
  "end": "2019-12-31",
  "repetition": {
    "type": "daily",
    "interval": 1
  }
}
```

---

## `DELETE` `/2.0/kb_order/{order_id}/repetition` — Delete a repetition

operationId: `DeleteOrderRepetition`

This action permanently deletes an order repetition. It cannot be undone.

### path Parameters

| Parameter | Type | Description |
|---|---|---|
| order_id *(required)* | integer <int32> | the id of the order |

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
