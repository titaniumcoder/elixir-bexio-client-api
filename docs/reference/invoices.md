# Invoices

Part of **Sales Order Management**. Extracted from docs.bexio.com (snapshot Mon, 28 Sep 2026 12:05:15 GMT). 26 operations.

| Method | Path | Title |
|---|---|---|
| `GET` | `/2.0/kb_invoice` | Fetch a list of invoices |
| `POST` | `/2.0/kb_invoice` | Create invoice |
| `POST` | `/2.0/kb_invoice/search` | Search invoices |
| `GET` | `/2.0/kb_invoice/{invoice_id}` | Fetch an invoice |
| `POST` | `/2.0/kb_invoice/{invoice_id}` | Edit an invoice |
| `DELETE` | `/2.0/kb_invoice/{invoice_id}` | Delete an invoice |
| `GET` | `/2.0/kb_invoice/{invoice_id}/pdf` | Show PDF |
| `POST` | `/2.0/kb_invoice/{invoice_id}/copy` | Copy a invoice |
| `POST` | `/2.0/kb_invoice/{invoice_id}/issue` | Issue an invoice |
| `POST` | `/2.0/kb_invoice/{invoice_id}/revert_issue` | Sets issued invoice to draft |
| `POST` | `/2.0/kb_invoice/{invoice_id}/cancel` | Cancel an invoice |
| `POST` | `/2.0/kb_invoice/{invoice_id}/mark_as_sent` | Mark invoice as sent |
| `POST` | `/2.0/kb_invoice/{invoice_id}/send` | Send an invoice |
| `GET` | `/2.0/kb_invoice/{invoice_id}/payment` | Fetch a list of payments |
| `POST` | `/2.0/kb_invoice/{invoice_id}/payment` | Create payment |
| `GET` | `/2.0/kb_invoice/{invoice_id}/payment/{payment_id}` | Fetch a payment |
| `DELETE` | `/2.0/kb_invoice/{invoice_id}/payment/{payment_id}` | Delete a payment |
| `GET` | `/2.0/kb_invoice/{invoice_id}/kb_reminder` | Fetch a list of reminders |
| `POST` | `/2.0/kb_invoice/{invoice_id}/kb_reminder` | Create reminder |
| `POST` | `/2.0/kb_invoice/{invoice_id}/kb_reminder/search` | Search invoice reminders |
| `GET` | `/2.0/kb_invoice/{invoice_id}/kb_reminder/{reminder_id}` | Fetch a reminder |
| `DELETE` | `/2.0/kb_invoice/{invoice_id}/kb_reminder/{reminder_id}` | Delete a reminder |
| `POST` | `/2.0/kb_invoice/{invoice_id}/kb_reminder/{reminder_id}/mark_as_sent` | Mark reminder as sent |
| `POST` | `/2.0/kb_invoice/{invoice_id}/kb_reminder/{reminder_id}/mark_as_unsent` | Mark reminder as unsent |
| `POST` | `/2.0/kb_invoice/{invoice_id}/kb_reminder/{reminder_id}/send` | Send a reminder |
| `GET` | `/2.0/kb_invoice/{invoice_id}/kb_reminder/{reminder_id}/pdf` | Show reminder PDF |

## `GET` `/2.0/kb_invoice` — Fetch a list of invoices

operationId: `v2ListInvoices`

This action fetches a list of all invoices

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
    "network_link": ""
  }
]
```

---

## `POST` `/2.0/kb_invoice` — Create invoice

operationId: `v2CreateInvoice`

This action creates a new invoice

### Request Body schema: application/json *(required)*

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
| is_valid_to | string <date> |  |
| contact_address_manual | string or null | This field can be used to set a contact address manually. If not in use or `null` the invoice address of the contact will be taken. |
| reference | string or null |  |
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
  "document_nr": "RE-00001",
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
  "is_valid_to": "2019-07-24",
  "contact_address_manual": "UTA Immobilien AG\nStadtturmstrasse 15\n5400 Baden",
  "reference": null,
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
      "type": "KbPositionCustom",
      "parent_id": null
    }
  ]
}
```

---

## `POST` `/2.0/kb_invoice/search` — Search invoices

operationId: `v2SearchInvoices`

Search invoices via query. Please refer to the Search section for detailed instructions.
The following search fields are supported:
- `id`
- `kb_item_status_id`
- `document_nr`
- `title`
- `api_reference`
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

## `GET` `/2.0/kb_invoice/{invoice_id}` — Fetch an invoice

operationId: `v2ShowInvoice`

This action fetches a single invoice

### path Parameters

| Parameter | Type | Description |
|---|---|---|
| invoice_id *(required)* | integer <int32> | the id of the invoice |

### Responses

200

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

---

## `POST` `/2.0/kb_invoice/{invoice_id}` — Edit an invoice

operationId: `v2EditInvoice`

This action edits a single invoice

### path Parameters

| Parameter | Type | Description |
|---|---|---|
| invoice_id *(required)* | integer <int32> | the id of the invoice |

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
| is_valid_to | string <date> |  |
| contact_address_manual | string or null | This field can be used to set a contact address manually. If not in use or `null` the invoice address of the contact will be taken. |
| reference | string or null |  |
| api_reference | string or null | This field can only be read and edited by the api. It can be used to save references to other systems. |
| template_slug | string or null | References a document template slug |

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
  "document_nr": "RE-00001",
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
  "is_valid_to": "2019-07-24",
  "contact_address_manual": "UTA Immobilien AG\nStadtturmstrasse 15\n5400 Baden",
  "reference": null,
  "api_reference": null,
  "template_slug": "581a8010821e01426b8b456b"
}
```

---

## `DELETE` `/2.0/kb_invoice/{invoice_id}` — Delete an invoice

operationId: `DeleteInvoice`

This action permanently deletes an invoice. It cannot be undone.

### path Parameters

| Parameter | Type | Description |
|---|---|---|
| invoice_id *(required)* | integer <int32> | the id of the invoice |

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

## `GET` `/2.0/kb_invoice/{invoice_id}/pdf` — Show PDF

operationId: `v2ShowInvoicePDF`

This action returns a pdf document of the invoice.

### path Parameters

| Parameter | Type | Description |
|---|---|---|
| invoice_id *(required)* | integer <int32> | the id of the invoice |
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

## `POST` `/2.0/kb_invoice/{invoice_id}/copy` — Copy a invoice

operationId: `v2CopyInvoice`

This action copies a invoice.

### path Parameters

| Parameter | Type | Description |
|---|---|---|
| invoice_id *(required)* | integer <int32> | the id of the invoice |

### Request Body schema: application/json

| Parameter | Type | Description |
|---|---|---|
| contact_id *(required)* | integer or null | References a contact object |
| contact_sub_id | integer or null | References a contact object |
| is_valid_from | string <date> |  |
| title | string or null |  |

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
  "contact_id": 14,
  "contact_sub_id": null,
  "is_valid_from": "2019-06-27",
  "title": null
}
```

---

## `POST` `/2.0/kb_invoice/{invoice_id}/issue` — Issue an invoice

operationId: `v2IssueInvoice`

This action issues an invoice. The invoice must be in the draft status.

### path Parameters

| Parameter | Type | Description |
|---|---|---|
| invoice_id *(required)* | integer <int32> | the id of the invoice |

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

## `POST` `/2.0/kb_invoice/{invoice_id}/revert_issue` — Sets issued invoice to draft

operationId: `v2RevertIssueInvoice`

This action set an already issued invoice to state draft.

### path Parameters

| Parameter | Type | Description |
|---|---|---|
| invoice_id *(required)* | integer <int32> | the id of the invoice |

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

## `POST` `/2.0/kb_invoice/{invoice_id}/cancel` — Cancel an invoice

operationId: `v2CancelInvoice`

This action cancels an already issued invoice.

### path Parameters

| Parameter | Type | Description |
|---|---|---|
| invoice_id *(required)* | integer <int32> | the id of the invoice |

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

## `POST` `/2.0/kb_invoice/{invoice_id}/mark_as_sent` — Mark invoice as sent

operationId: `v2RMarkAsSentInvoice`

This action marks an invoice as sent

### path Parameters

| Parameter | Type | Description |
|---|---|---|
| invoice_id *(required)* | integer <int32> | the id of the invoice |

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

## `POST` `/2.0/kb_invoice/{invoice_id}/send` — Send an invoice

operationId: `v2SendInvoice`

This action sends an invoice by email.

### path Parameters

| Parameter | Type | Description |
|---|---|---|
| invoice_id *(required)* | integer <int32> | the id of the invoice |

### Request Body schema: application/json

| Parameter | Type | Description |
|---|---|---|
| recipient_email *(required)* | string | During the trial period, the recipient is limited to the email address associated to the access token provided. |
| subject *(required)* | string |  |
| message *(required)* | string | The placeholder "[Network Link]" must be part of the text. |
| mark_as_open | boolean |  |
| attach_pdf | boolean | Attach PDF directly to the email |

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

**Request sample**:

```json
{
  "recipient_email": "example@bexio.com",
  "subject": "Your new document",
  "message": "Please find the document at [Network Link]",
  "mark_as_open": true,
  "attach_pdf": true
}
```

---

## `GET` `/2.0/kb_invoice/{invoice_id}/payment` — Fetch a list of payments

operationId: `v2ListInvoicePayments`

This action fetches a list of all payments for the invoice

### path Parameters

| Parameter | Type | Description |
|---|---|---|
| invoice_id *(required)* | integer <int32> | the id of the invoice |

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
    "date": "2019-06-29",
    "value": "10.0000",
    "bank_account_id": 1,
    "title": "Received Payment",
    "payment_service_id": null,
    "is_client_account_redemption": false,
    "is_cash_discount": false,
    "kb_invoice_id": 1,
    "kb_credit_voucher_id": null,
    "kb_bill_id": null,
    "kb_credit_voucher_text": ""
  }
]
```

---

## `POST` `/2.0/kb_invoice/{invoice_id}/payment` — Create payment

operationId: `v2CreateInvoicePayment`

This action creates a new payment for an invoice

### path Parameters

| Parameter | Type | Description |
|---|---|---|
| invoice_id *(required)* | integer <int32> | the id of the invoice |

### Request Body schema: application/json *(required)*

| Parameter | Type | Description |
|---|---|---|
| date | string <date> |  |
| value *(required)* | string |  |
| bank_account_id | integer or null | References a bank account object |
| payment_service_id | integer or null Enum: 0 1 2 | value description 1 PayPal 2 Stripe 3 SIX Payments |

### Responses

201, 422

**201** — Created

**Response samples** (201):

```json
{
  "id": 4,
  "date": "2019-06-29",
  "value": "10.0000",
  "bank_account_id": 1,
  "title": "Received Payment",
  "payment_service_id": null,
  "is_client_account_redemption": false,
  "is_cash_discount": false,
  "kb_invoice_id": 1,
  "kb_credit_voucher_id": null,
  "kb_bill_id": null,
  "kb_credit_voucher_text": ""
}
```

**422** — Validation error

**Request sample**:

```json
{
  "date": "2019-06-29",
  "value": "10.0000",
  "bank_account_id": 1,
  "payment_service_id": null
}
```

---

## `GET` `/2.0/kb_invoice/{invoice_id}/payment/{payment_id}` — Fetch a payment

operationId: `v2ShowInvoicePayment`

This action fetches a payment

### path Parameters

| Parameter | Type | Description |
|---|---|---|
| invoice_id *(required)* | integer <int32> | the id of the invoice |
| payment_id *(required)* | integer <int32> | the id of the payment |

### Responses

200

**200** — OK

**Response samples** (200):

```json
{
  "id": 4,
  "date": "2019-06-29",
  "value": "10.0000",
  "bank_account_id": 1,
  "title": "Received Payment",
  "payment_service_id": null,
  "is_client_account_redemption": false,
  "is_cash_discount": false,
  "kb_invoice_id": 1,
  "kb_credit_voucher_id": null,
  "kb_bill_id": null,
  "kb_credit_voucher_text": ""
}
```

---

## `DELETE` `/2.0/kb_invoice/{invoice_id}/payment/{payment_id}` — Delete a payment

operationId: `DeleteInvoicePayment`

This action permanently deletes a payment. It cannot be undone.

### path Parameters

| Parameter | Type | Description |
|---|---|---|
| invoice_id *(required)* | integer <int32> | the id of the invoice |
| payment_id *(required)* | integer <int32> | the id of the payment |

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

## `GET` `/2.0/kb_invoice/{invoice_id}/kb_reminder` — Fetch a list of reminders

operationId: `v2ListInvoiceReminders`

This action fetches a list of all reminders for the invoice

### path Parameters

| Parameter | Type | Description |
|---|---|---|
| invoice_id *(required)* | integer <int32> | the id of the invoice |

### Responses

200

**200** — OK

**Response samples** (200):

```json
[
  {
    "id": 4,
    "kb_invoice_id": 1,
    "title": "First reminder",
    "is_valid_from": "2019-06-24",
    "is_valid_to": "2019-07-24",
    "reminder_period_in_days": 14,
    "reminder_level": 1,
    "show_positions": true,
    "remaining_price": "17.8000",
    "received_total": "0.0000",
    "is_sent": false,
    "header": null,
    "footer": null
  }
]
```

---

## `POST` `/2.0/kb_invoice/{invoice_id}/kb_reminder` — Create reminder

operationId: `v2CreateInvoiceReminder`

This action creates a new reminder for an invoice

### path Parameters

| Parameter | Type | Description |
|---|---|---|
| invoice_id *(required)* | integer <int32> | the id of the invoice |

### Responses

201, 400

**201** — Created

**Response samples** (201):

```json
{
  "id": 4,
  "kb_invoice_id": 1,
  "title": "First reminder",
  "is_valid_from": "2019-06-24",
  "is_valid_to": "2019-07-24",
  "reminder_period_in_days": 14,
  "reminder_level": 1,
  "show_positions": true,
  "remaining_price": "17.8000",
  "received_total": "0.0000",
  "is_sent": false,
  "header": null,
  "footer": null
}
```

**400** — Bad Request

---

## `POST` `/2.0/kb_invoice/{invoice_id}/kb_reminder/search` — Search invoice reminders

operationId: `v2SearchReminders`

Search invoice reminders via query. Please refer to the Search section for detailed instructions.
The following search fields are supported:
- `title`
- `reminder_level`
- `is_sent`
- `is_valid_from`
- `is_valid_to`

### path Parameters

| Parameter | Type | Description |
|---|---|---|
| invoice_id *(required)* | integer <int32> | the id of the invoice |

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
    "kb_invoice_id": 1,
    "title": "First reminder",
    "is_valid_from": "2019-06-24",
    "is_valid_to": "2019-07-24",
    "reminder_period_in_days": 14,
    "reminder_level": 1,
    "show_positions": true,
    "remaining_price": "17.8000",
    "received_total": "0.0000",
    "is_sent": false,
    "header": null,
    "footer": null
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

## `GET` `/2.0/kb_invoice/{invoice_id}/kb_reminder/{reminder_id}` — Fetch a reminder

operationId: `v2ShowInvoiceReminder`

This action deletes the most recent reminder

### path Parameters

| Parameter | Type | Description |
|---|---|---|
| invoice_id *(required)* | integer <int32> | the id of the invoice |
| reminder_id *(required)* | integer <int32> | the id of the reminder |

### Responses

200

**200** — OK

**Response samples** (200):

```json
{
  "id": 4,
  "kb_invoice_id": 1,
  "title": "First reminder",
  "is_valid_from": "2019-06-24",
  "is_valid_to": "2019-07-24",
  "reminder_period_in_days": 14,
  "reminder_level": 1,
  "show_positions": true,
  "remaining_price": "17.8000",
  "received_total": "0.0000",
  "is_sent": false,
  "header": null,
  "footer": null
}
```

---

## `DELETE` `/2.0/kb_invoice/{invoice_id}/kb_reminder/{reminder_id}` — Delete a reminder

operationId: `v2DeleteInvoiceReminder`

This action permanently deletes the most recent reminder. It cannot be undone.

### path Parameters

| Parameter | Type | Description |
|---|---|---|
| invoice_id *(required)* | integer <int32> | the id of the invoice |
| reminder_id *(required)* | integer <int32> | the id of the reminder |

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

## `POST` `/2.0/kb_invoice/{invoice_id}/kb_reminder/{reminder_id}/mark_as_sent` — Mark reminder as sent

operationId: `v2RMarkAsSentInvoiceReminder`

This action marks an invoice reminder as sent

### path Parameters

| Parameter | Type | Description |
|---|---|---|
| invoice_id *(required)* | integer <int32> | the id of the invoice |
| reminder_id *(required)* | integer <int32> | the id of the reminder |

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

## `POST` `/2.0/kb_invoice/{invoice_id}/kb_reminder/{reminder_id}/mark_as_unsent` — Mark reminder as unsent

operationId: `v2RMarkAsUnsentInvoiceReminder`

This action marks an invoice reminder as unsent

### path Parameters

| Parameter | Type | Description |
|---|---|---|
| invoice_id *(required)* | integer <int32> | the id of the invoice |
| reminder_id *(required)* | integer <int32> | the id of the reminder |

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

## `POST` `/2.0/kb_invoice/{invoice_id}/kb_reminder/{reminder_id}/send` — Send a reminder

operationId: `v2SendInvoiceReminder`

This action sends an invoice reminder by email.

### path Parameters

| Parameter | Type | Description |
|---|---|---|
| invoice_id *(required)* | integer <int32> | the id of the invoice |
| reminder_id *(required)* | integer <int32> | the id of the reminder |

### Request Body schema: application/json

| Parameter | Type | Description |
|---|---|---|
| recipient_email *(required)* | string | During the trial period, the recipient is limited to the email address associated to the access token provided. |
| subject *(required)* | string |  |
| message *(required)* | string | The placeholder "[Network Link]" must be part of the text. |

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

**Request sample**:

```json
{
  "recipient_email": "example@bexio.com",
  "subject": "Your new document",
  "message": "Please find the document at [Network Link]"
}
```

---

## `GET` `/2.0/kb_invoice/{invoice_id}/kb_reminder/{reminder_id}/pdf` — Show reminder PDF

operationId: `v2ShowInvoiceReminderPDF`

This action returns a pdf document of the invoice reminder.

### path Parameters

| Parameter | Type | Description |
|---|---|---|
| invoice_id *(required)* | integer <int32> | the id of the invoice |
| reminder_id *(required)* | integer <int32> | the id of the reminder |
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
