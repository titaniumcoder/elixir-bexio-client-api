# Purchase Orders

Part of **Purchase**. Extracted from docs.bexio.com (snapshot Mon, 28 Sep 2026 12:05:15 GMT). 5 operations.

| Method | Path | Title |
|---|---|---|
| `GET` | `/3.0/purchase_orders` | Fetch a list of purchase orders |
| `POST` | `/3.0/purchase_orders` | Create a purchase order |
| `GET` | `/3.0/purchase_orders/{purchase_order_id}` | Fetch a single purchase order |
| `PUT` | `/3.0/purchase_orders/{purchase_order_id}` | Update a single purchase order |
| `DELETE` | `/3.0/purchase_orders/{purchase_order_id}` | Delete a purchase order |

## `GET` `/3.0/purchase_orders` — Fetch a list of purchase orders

operationId: `v3PurchaseOrderList`

This action fetches a list of article orders

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
    "id": 1,
    "document_nr": "RE-00001",
    "kb_payment_template_id": 1,
    "payment_type_id": 1,
    "title": "purchase order example title",
    "contact_id": 14,
    "contact_sub_id": 1,
    "template_slug": "581a8010821e01426b8b456b",
    "user_id": 1,
    "project_id": 1,
    "logopaper_id": 1,
    "language": {
      "id": 1,
      "name": "Deutsch",
      "decimalpoint": ".",
      "thousandsseparator": "'",
      "iso_639_1": "de",
      "date_format": "d.m.Y"
    },
    "language_id": 1,
    "bank_account_id": 1,
    "currency": {
      "id": 1,
      "name": "CHF",
      "round_factor": 0.05
    },
    "currency_id": 1,
    "header": "We would like to order the following products:",
    "footer": "Many thanks for the fast processing of our order.",
    "total_rounding_difference": -0.02,
    "mwst_type": "included",
    "mwst_is_net": true,
    "is_compact_view": false,
    "show_position_taxes": false,
    "salesman_user_id": 1,
    "is_valid_from": "2019-06-24",
    "is_valid_to": "2019-07-24",
    "delivery_address_type": "contact_address",
    "contact_address_manual": "bexio AG\\nReinluftweg 1\\nCH - 9630 Wattwil",
    "delivery_address_manual": "bexio AG\\nReinluftweg 1\\nCH - 9630 Wattwil",
    "nb_decimals_amount": 2,
    "nb_decimals_price": 2,
    "kb_item_status_id": 22,
    "terms_of_payment_text": "Payable within 30 days",
    "reference": "Based on Quote Q-3860",
    "api_reference": null,
    "mail": "support@bexio.com",
    "viewed_by_client_at": "2020-07-24",
    "is_valid_until": "2019-07-24",
    "created_at": "2020-04-28T19:58:58+00:00",
    "updated_at": "2020-04-30T19:58:58+00:00",
    "custom_translations": {},
    "date_format": "d.m.Y"
  }
]
```

---

## `POST` `/3.0/purchase_orders` — Create a purchase order

operationId: `v3PurchaseOrderCreate`

This action creates a new purchase order

### Request Body schema: application/json *(required)*

| Parameter | Type | Description |
|---|---|---|
| id | integer <int32> | The id of the purchase order |
| document_nr | string |  |
| kb_payment_template_id | integer or null |  |
| payment_type_id | integer | References a payment type object |
| title | string or null |  |
| contact_id | integer | References a contact object |
| contact_sub_id | integer or null | References a contact object |
| template_slug | string or null |  |
| user_id | integer | References a user object |
| project_id | integer or null | References a project object |
| logopaper_id | integer |  |
| language | object |  |
| language_id | integer | References a language object |
| bank_account_id | integer | References a bank account object |
| currency | object |  |
| currency_id | integer | References a currency object |
| header | string or null |  |
| footer | string or null |  |
| mwst_type | string Enum: included excluded exempt | Possible values are - `included` - included means that the tax is included in the total price - `excluded` - excluded means that the tax is excluded from the total price - `exempt` - exempt means that no tax is charged |
| mwst_is_net | boolean | This value affects the total if the field `mwst_type` has been set to 0. `false` = Taxes are included in the total `true` = Taxes will be added to the total |
| is_compact_view | boolean |  |
| show_position_taxes | boolean |  |
| salesman_user_id | integer or null | References a user object |
| is_valid_from | string <date> |  |
| is_valid_to | string <date> |  |
| delivery_address_type | string Enum: contact_address manual |  |
| contact_address_manual | string | The contact address for the document. Newlines are in the format `\n` |
| delivery_address_manual | string | The delivery address for order. Newlines are in the format `\n` |
| nb_decimals_amount | integer <int32> Default: 2 | The maximum number of decimal digits to display for amounts (number of items). |
| nb_decimals_price | integer <int32> Default: 2 | The maximum number of decimal digits to display for prices (line item prices, totals, etc.). |
| terms_of_payment_text | string or null | Additional text which is displayed below the terms of payment |
| reference | string or null | A reference which can be added to the document by the client. |
| api_reference | string or null | This field can only be read and edited by the api. It can be used to save references to other systems. |
| mail | string or null | The mail address of the company |
| is_valid_until | string <date> |  |
| created_at | string <date> | Creation date of the purchase order |
| updated_at | string <date> | Last time when purchase order was updated |
| custom_translations | object |  |
| date_format | string |  |
| positions | object | A purchase order can have multiple line items (positions). Please note that the line items must be grouped by required, optional and discount positions. |

### Responses

201, 422

**201** — Created

**Response samples** (201):

```json
{
  "id": 1,
  "document_nr": "RE-00001",
  "kb_payment_template_id": 1,
  "payment_type_id": 1,
  "title": "purchase order example title",
  "contact_id": 14,
  "contact_sub_id": 1,
  "template_slug": "581a8010821e01426b8b456b",
  "user_id": 1,
  "project_id": 1,
  "logopaper_id": 1,
  "language": {
    "id": 1,
    "name": "Deutsch",
    "decimalpoint": ".",
    "thousandsseparator": "'",
    "iso_639_1": "de",
    "date_format": "d.m.Y"
  },
  "language_id": 1,
  "bank_account_id": 1,
  "currency": {
    "id": 1,
    "name": "CHF",
    "round_factor": 0.05
  },
  "currency_id": 1,
  "header": "We would like to order the following products:",
  "footer": "Many thanks for the fast processing of our order.",
  "total_rounding_difference": -0.02,
  "mwst_type": "included",
  "mwst_is_net": true,
  "is_compact_view": false,
  "show_position_taxes": false,
  "salesman_user_id": 1,
  "is_valid_from": "2019-06-24",
  "is_valid_to": "2019-07-24",
  "delivery_address_type": "contact_address",
  "contact_address_manual": "bexio AG\\nReinluftweg 1\\nCH - 9630 Wattwil",
  "delivery_address_manual": "bexio AG\\nReinluftweg 1\\nCH - 9630 Wattwil",
  "nb_decimals_amount": 2,
  "nb_decimals_price": 2,
  "kb_item_status_id": 22,
  "terms_of_payment_text": "Payable within 30 days",
  "reference": "Based on Quote Q-3860",
  "api_reference": null,
  "mail": "support@bexio.com",
  "viewed_by_client_at": "2020-07-24",
  "is_valid_until": "2019-07-24",
  "created_at": "2020-04-28T19:58:58+00:00",
  "updated_at": "2020-04-30T19:58:58+00:00",
  "custom_translations": {},
  "date_format": "d.m.Y",
  "positions": {
    "required": [
      {
        "type": "text",
        "pos": null,
        "is_optional": false,
        "id": 1,
        "text": "This position type allows to add free text to a document",
        "show_pos_nr": false
      }
    ],
    "optional": [
      {
        "type": "text",
        "pos": null,
        "is_optional": false,
        "id": 1,
        "text": "This position type allows to add free text to a document",
        "show_pos_nr": false
      }
    ],
    "discount": [
      {
        "type": "discount",
        "pos": null,
        "is_optional": false,
        "id": 1,
        "text": "Partner discount",
        "is_percentual": true,
        "value": 10,
        "discount_total": 1.78
      }
    ]
  }
}
```

**422** — Validation error

**Request sample**:

```json
{
  "id": 1,
  "document_nr": "RE-00001",
  "kb_payment_template_id": 1,
  "payment_type_id": 1,
  "title": "purchase order example title",
  "contact_id": 14,
  "contact_sub_id": 1,
  "template_slug": "581a8010821e01426b8b456b",
  "user_id": 1,
  "project_id": 1,
  "logopaper_id": 1,
  "language": {
    "id": 1,
    "name": "Deutsch",
    "decimalpoint": ".",
    "thousandsseparator": "'",
    "iso_639_1": "de",
    "date_format": "d.m.Y"
  },
  "language_id": 1,
  "bank_account_id": 1,
  "currency": {
    "id": 1,
    "name": "CHF",
    "round_factor": 0.05
  },
  "currency_id": 1,
  "header": "We would like to order the following products:",
  "footer": "Many thanks for the fast processing of our order.",
  "mwst_type": "included",
  "mwst_is_net": true,
  "is_compact_view": false,
  "show_position_taxes": false,
  "salesman_user_id": 1,
  "is_valid_from": "2019-06-24",
  "is_valid_to": "2019-07-24",
  "delivery_address_type": "contact_address",
  "contact_address_manual": "bexio AG\\nReinluftweg 1\\nCH - 9630 Wattwil",
  "delivery_address_manual": "bexio AG\\nReinluftweg 1\\nCH - 9630 Wattwil",
  "nb_decimals_amount": 2,
  "nb_decimals_price": 2,
  "terms_of_payment_text": "Payable within 30 days",
  "reference": "Based on Quote Q-3860",
  "api_reference": null,
  "mail": "support@bexio.com",
  "is_valid_until": "2019-07-24",
  "created_at": "2020-04-28T19:58:58+00:00",
  "updated_at": "2020-04-30T19:58:58+00:00",
  "custom_translations": {},
  "date_format": "d.m.Y",
  "positions": {
    "required": [
      {
        "type": "text",
        "pos": null,
        "is_optional": false,
        "id": 1,
        "text": "This position type allows to add free text to a document",
        "show_pos_nr": false
      }
    ],
    "optional": [
      {
        "type": "text",
        "pos": null,
        "is_optional": false,
        "id": 1,
        "text": "This position type allows to add free text to a document",
        "show_pos_nr": false
      }
    ],
    "discount": [
      {
        "type": "discount",
        "pos": null,
        "is_optional": false,
        "id": 1,
        "text": "Partner discount",
        "is_percentual": true,
        "value": 10,
        "discount_total": 1.78
      }
    ]
  }
}
```

---

## `GET` `/3.0/purchase_orders/{purchase_order_id}` — Fetch a single purchase order

operationId: `v3PurchaseOrderShow`

This action fetches a single purchase order

### path Parameters

| Parameter | Type | Description |
|---|---|---|
| purchase_order_id *(required)* | integer <int32> | the id of the purchase order |

### Responses

200

**200** — OK

**Response samples** (200):

```json
{
  "id": 1,
  "document_nr": "RE-00001",
  "kb_payment_template_id": 1,
  "payment_type_id": 1,
  "title": "purchase order example title",
  "contact_id": 14,
  "contact_sub_id": 1,
  "template_slug": "581a8010821e01426b8b456b",
  "user_id": 1,
  "project_id": 1,
  "logopaper_id": 1,
  "language": {
    "id": 1,
    "name": "Deutsch",
    "decimalpoint": ".",
    "thousandsseparator": "'",
    "iso_639_1": "de",
    "date_format": "d.m.Y"
  },
  "language_id": 1,
  "bank_account_id": 1,
  "currency": {
    "id": 1,
    "name": "CHF",
    "round_factor": 0.05
  },
  "currency_id": 1,
  "header": "We would like to order the following products:",
  "footer": "Many thanks for the fast processing of our order.",
  "total_rounding_difference": -0.02,
  "mwst_type": "included",
  "mwst_is_net": true,
  "is_compact_view": false,
  "show_position_taxes": false,
  "salesman_user_id": 1,
  "is_valid_from": "2019-06-24",
  "is_valid_to": "2019-07-24",
  "delivery_address_type": "contact_address",
  "contact_address_manual": "bexio AG\\nReinluftweg 1\\nCH - 9630 Wattwil",
  "delivery_address_manual": "bexio AG\\nReinluftweg 1\\nCH - 9630 Wattwil",
  "nb_decimals_amount": 2,
  "nb_decimals_price": 2,
  "kb_item_status_id": 22,
  "terms_of_payment_text": "Payable within 30 days",
  "reference": "Based on Quote Q-3860",
  "api_reference": null,
  "mail": "support@bexio.com",
  "viewed_by_client_at": "2020-07-24",
  "is_valid_until": "2019-07-24",
  "created_at": "2020-04-28T19:58:58+00:00",
  "updated_at": "2020-04-30T19:58:58+00:00",
  "custom_translations": {},
  "date_format": "d.m.Y"
}
```

---

## `PUT` `/3.0/purchase_orders/{purchase_order_id}` — Update a single purchase order

operationId: `v3PurchaseOrderUpdate`

This action updates a purchase order.

### path Parameters

| Parameter | Type | Description |
|---|---|---|
| purchase_order_id *(required)* | integer <int32> | the id of the purchase order |

### Request Body schema: application/json

| Parameter | Type | Description |
|---|---|---|
| id | integer <int32> | The id of the purchase order |
| document_nr | string |  |
| kb_payment_template_id | integer or null |  |
| payment_type_id | integer | References a payment type object |
| title | string or null |  |
| contact_id | integer | References a contact object |
| contact_sub_id | integer or null | References a contact object |
| template_slug | string or null |  |
| user_id | integer | References a user object |
| project_id | integer or null | References a project object |
| logopaper_id | integer |  |
| language | object |  |
| language_id | integer | References a language object |
| bank_account_id | integer | References a bank account object |
| currency | object |  |
| currency_id | integer | References a currency object |
| header | string or null |  |
| footer | string or null |  |
| mwst_type | string Enum: included excluded exempt | Possible values are - `included` - included means that the tax is included in the total price - `excluded` - excluded means that the tax is excluded from the total price - `exempt` - exempt means that no tax is charged |
| mwst_is_net | boolean | This value affects the total if the field `mwst_type` has been set to 0. `false` = Taxes are included in the total `true` = Taxes will be added to the total |
| is_compact_view | boolean |  |
| show_position_taxes | boolean |  |
| salesman_user_id | integer or null | References a user object |
| is_valid_from | string <date> |  |
| is_valid_to | string <date> |  |
| delivery_address_type | string Enum: contact_address manual |  |
| contact_address_manual | string | The contact address for the document. Newlines are in the format `\n` |
| delivery_address_manual | string | The delivery address for order. Newlines are in the format `\n` |
| nb_decimals_amount | integer <int32> Default: 2 | The maximum number of decimal digits to display for amounts (number of items). |
| nb_decimals_price | integer <int32> Default: 2 | The maximum number of decimal digits to display for prices (line item prices, totals, etc.). |
| terms_of_payment_text | string or null | Additional text which is displayed below the terms of payment |
| reference | string or null | A reference which can be added to the document by the client. |
| api_reference | string or null | This field can only be read and edited by the api. It can be used to save references to other systems. |
| mail | string or null | The mail address of the company |
| is_valid_until | string <date> |  |
| created_at | string <date> | Creation date of the purchase order |
| updated_at | string <date> | Last time when purchase order was updated |
| custom_translations | object |  |
| date_format | string |  |

### Responses

200, 422

**200** — OK

**Response samples** (200):

```json
{
  "id": 1,
  "document_nr": "RE-00001",
  "kb_payment_template_id": 1,
  "payment_type_id": 1,
  "title": "purchase order example title",
  "contact_id": 14,
  "contact_sub_id": 1,
  "template_slug": "581a8010821e01426b8b456b",
  "user_id": 1,
  "project_id": 1,
  "logopaper_id": 1,
  "language": {
    "id": 1,
    "name": "Deutsch",
    "decimalpoint": ".",
    "thousandsseparator": "'",
    "iso_639_1": "de",
    "date_format": "d.m.Y"
  },
  "language_id": 1,
  "bank_account_id": 1,
  "currency": {
    "id": 1,
    "name": "CHF",
    "round_factor": 0.05
  },
  "currency_id": 1,
  "header": "We would like to order the following products:",
  "footer": "Many thanks for the fast processing of our order.",
  "total_rounding_difference": -0.02,
  "mwst_type": "included",
  "mwst_is_net": true,
  "is_compact_view": false,
  "show_position_taxes": false,
  "salesman_user_id": 1,
  "is_valid_from": "2019-06-24",
  "is_valid_to": "2019-07-24",
  "delivery_address_type": "contact_address",
  "contact_address_manual": "bexio AG\\nReinluftweg 1\\nCH - 9630 Wattwil",
  "delivery_address_manual": "bexio AG\\nReinluftweg 1\\nCH - 9630 Wattwil",
  "nb_decimals_amount": 2,
  "nb_decimals_price": 2,
  "kb_item_status_id": 22,
  "terms_of_payment_text": "Payable within 30 days",
  "reference": "Based on Quote Q-3860",
  "api_reference": null,
  "mail": "support@bexio.com",
  "viewed_by_client_at": "2020-07-24",
  "is_valid_until": "2019-07-24",
  "created_at": "2020-04-28T19:58:58+00:00",
  "updated_at": "2020-04-30T19:58:58+00:00",
  "custom_translations": {},
  "date_format": "d.m.Y",
  "positions": {
    "required": [
      {
        "type": "text",
        "pos": null,
        "is_optional": false,
        "id": 1,
        "text": "This position type allows to add free text to a document",
        "show_pos_nr": false
      }
    ],
    "optional": [
      {
        "type": "text",
        "pos": null,
        "is_optional": false,
        "id": 1,
        "text": "This position type allows to add free text to a document",
        "show_pos_nr": false
      }
    ],
    "discount": [
      {
        "type": "discount",
        "pos": null,
        "is_optional": false,
        "id": 1,
        "text": "Partner discount",
        "is_percentual": true,
        "value": 10,
        "discount_total": 1.78
      }
    ]
  }
}
```

**422** — Validation error

**Request sample**:

```json
{
  "id": 1,
  "document_nr": "RE-00001",
  "kb_payment_template_id": 1,
  "payment_type_id": 1,
  "title": "purchase order example title",
  "contact_id": 14,
  "contact_sub_id": 1,
  "template_slug": "581a8010821e01426b8b456b",
  "user_id": 1,
  "project_id": 1,
  "logopaper_id": 1,
  "language": {
    "id": 1,
    "name": "Deutsch",
    "decimalpoint": ".",
    "thousandsseparator": "'",
    "iso_639_1": "de",
    "date_format": "d.m.Y"
  },
  "language_id": 1,
  "bank_account_id": 1,
  "currency": {
    "id": 1,
    "name": "CHF",
    "round_factor": 0.05
  },
  "currency_id": 1,
  "header": "We would like to order the following products:",
  "footer": "Many thanks for the fast processing of our order.",
  "mwst_type": "included",
  "mwst_is_net": true,
  "is_compact_view": false,
  "show_position_taxes": false,
  "salesman_user_id": 1,
  "is_valid_from": "2019-06-24",
  "is_valid_to": "2019-07-24",
  "delivery_address_type": "contact_address",
  "contact_address_manual": "bexio AG\\nReinluftweg 1\\nCH - 9630 Wattwil",
  "delivery_address_manual": "bexio AG\\nReinluftweg 1\\nCH - 9630 Wattwil",
  "nb_decimals_amount": 2,
  "nb_decimals_price": 2,
  "terms_of_payment_text": "Payable within 30 days",
  "reference": "Based on Quote Q-3860",
  "api_reference": null,
  "mail": "support@bexio.com",
  "is_valid_until": "2019-07-24",
  "created_at": "2020-04-28T19:58:58+00:00",
  "updated_at": "2020-04-30T19:58:58+00:00",
  "custom_translations": {},
  "date_format": "d.m.Y"
}
```

---

## `DELETE` `/3.0/purchase_orders/{purchase_order_id}` — Delete a purchase order

operationId: `v3PurchaseOrderDelete`

This action permanently deletes a purchase order. It cannot be undone.

### path Parameters

| Parameter | Type | Description |
|---|---|---|
| purchase_order_id *(required)* | integer <int32> | the id of the purchase order |

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
