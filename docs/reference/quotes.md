# Quotes

Part of **Sales Order Management**. Extracted from docs.bexio.com (snapshot Mon, 28 Sep 2026 12:05:15 GMT). 17 operations.

| Method | Path | Title |
|---|---|---|
| `GET` | `/2.0/kb_offer` | Fetch a list of quotes |
| `POST` | `/2.0/kb_offer` | Create quote |
| `POST` | `/2.0/kb_offer/search` | Search quotes |
| `GET` | `/2.0/kb_offer/{quote_id}` | Fetch a quote |
| `POST` | `/2.0/kb_offer/{quote_id}` | Edit a quote |
| `DELETE` | `/2.0/kb_offer/{quote_id}` | Delete a quote |
| `POST` | `/2.0/kb_offer/{quote_id}/issue` | Issue a quote |
| `POST` | `/2.0/kb_offer/{quote_id}/revertIssue` | Revert issue a quote |
| `POST` | `/2.0/kb_offer/{quote_id}/accept` | Accept a quote |
| `POST` | `/2.0/kb_offer/{quote_id}/reject` | Decline a quote |
| `POST` | `/2.0/kb_offer/{quote_id}/reissue` | Reissue a quote |
| `POST` | `/2.0/kb_offer/{quote_id}/mark_as_sent` | Mark quote as sent |
| `GET` | `/2.0/kb_offer/{quote_id}/pdf` | Show PDF |
| `POST` | `/2.0/kb_offer/{quote_id}/send` | Send a quote |
| `POST` | `/2.0/kb_offer/{quote_id}/copy` | Copy a quote |
| `POST` | `/2.0/kb_offer/{quote_id}/order` | Create order from quote |
| `POST` | `/2.0/kb_offer/{quote_id}/invoice` | Create invoice from quote |

## `GET` `/2.0/kb_offer` — Fetch a list of quotes

operationId: `v2ListQuotes`

This action fetches a list of all quotes

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
    "document_nr": "AN-00001",
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
    "is_valid_until": "2019-07-24",
    "contact_address": "Muster AG\nMusterstrasse 15\n8640 Rapperswil",
    "delivery_address_type": 0,
    "delivery_address": "Muster AG\nMusterstrasse 15\n8640 Rapperswil",
    "kb_item_status_id": 3,
    "api_reference": null,
    "viewed_by_client_at": null,
    "kb_terms_of_payment_template_id": null,
    "show_total": true,
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

## `POST` `/2.0/kb_offer` — Create quote

operationId: `v2CreateQuote`

This action creates a new quote

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
| is_valid_until | string <date> |  |
| contact_address_manual | string or null | This field can be used to set a contact address manually. If not in use or `null` the invoice address of the contact will be taken. |
| delivery_address_type | integer Enum: 0 1 | value description 0 use invoice address 1 use custom address |
| delivery_address_manual | string or null | This field can be used to set a delivery address manually if `delivery_address_type` is set to `1`. If not in use or `null` the invoice address will be taken. |
| api_reference | string or null | This field can only be read and edited by the api. It can be used to save references to other systems. |
| viewed_by_client_at | string or null |  |
| kb_terms_of_payment_template_id | integer or null |  |
| template_slug | string or null | References a document template slug |
| positions | array | Please note that you can combine multiple positions. This means that an array containing `KbPositionCustom` and `KbPositionArticle` positions is valid. Recommendation: use a maximum of 150 positions when creating sales documents. Other positions can be added using the item creation endpoint. |

### Responses

201, 422

**201** — Created

**Response samples** (201):

```json
{
  "id": 4,
  "document_nr": "AN-00001",
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
  "is_valid_until": "2019-07-24",
  "contact_address": "Muster AG\nMusterstrasse 15\n8640 Rapperswil",
  "delivery_address_type": 0,
  "delivery_address": "Muster AG\nMusterstrasse 15\n8640 Rapperswil",
  "kb_item_status_id": 3,
  "api_reference": null,
  "viewed_by_client_at": null,
  "kb_terms_of_payment_template_id": null,
  "show_total": true,
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
  "document_nr": "AN-00001",
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
  "is_valid_until": "2019-07-24",
  "contact_address_manual": "UTA Immobilien AG\nStadtturmstrasse 15\n5400 Baden",
  "delivery_address_type": 0,
  "delivery_address_manual": "UTA Immobilien AG\nStadtturmstrasse 15\n5400 Baden",
  "api_reference": null,
  "viewed_by_client_at": null,
  "kb_terms_of_payment_template_id": null,
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

## `POST` `/2.0/kb_offer/search` — Search quotes

operationId: `v2SearchQuotes`

Search quotes via query. Please refer to the Search section for detailed instructions.
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
- `is_valid_until`
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
    "document_nr": "AN-00001",
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
    "is_valid_until": "2019-07-24",
    "contact_address": "Muster AG\nMusterstrasse 15\n8640 Rapperswil",
    "delivery_address_type": 0,
    "delivery_address": "Muster AG\nMusterstrasse 15\n8640 Rapperswil",
    "kb_item_status_id": 3,
    "api_reference": null,
    "viewed_by_client_at": null,
    "kb_terms_of_payment_template_id": null,
    "show_total": true,
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

## `GET` `/2.0/kb_offer/{quote_id}` — Fetch a quote

operationId: `v2ShowQuote`

This action fetches a single quote

### path Parameters

| Parameter | Type | Description |
|---|---|---|
| quote_id *(required)* | integer <int32> | the id of the quote |

### Responses

200

**200** — OK

**Response samples** (200):

```json
{
  "id": 4,
  "document_nr": "AN-00001",
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
  "is_valid_until": "2019-07-24",
  "contact_address": "Muster AG\nMusterstrasse 15\n8640 Rapperswil",
  "delivery_address_type": 0,
  "delivery_address": "Muster AG\nMusterstrasse 15\n8640 Rapperswil",
  "kb_item_status_id": 3,
  "api_reference": null,
  "viewed_by_client_at": null,
  "kb_terms_of_payment_template_id": null,
  "show_total": true,
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

## `POST` `/2.0/kb_offer/{quote_id}` — Edit a quote

operationId: `v2EditQuote`

This action edits a single quote

### path Parameters

| Parameter | Type | Description |
|---|---|---|
| quote_id *(required)* | integer <int32> | the id of the quote |

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
| is_valid_until | string <date> |  |
| contact_address_manual | string or null | This field can be used to set a contact address manually. If not in use or `null` the invoice address of the contact will be taken. |
| delivery_address_type | integer Enum: 0 1 | value description 0 use invoice address 1 use custom address |
| delivery_address_manual | string or null | This field can be used to set a delivery address manually if `delivery_address_type` is set to `1`. If not in use or `null` the invoice address will be taken. |
| api_reference | string or null | This field can only be read and edited by the api. It can be used to save references to other systems. |
| viewed_by_client_at | string or null |  |
| kb_terms_of_payment_template_id | integer or null |  |
| template_slug | string or null | References a document template slug |

### Responses

200, 422

**200** — OK

**Response samples** (200):

```json
{
  "id": 4,
  "document_nr": "AN-00001",
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
  "is_valid_until": "2019-07-24",
  "contact_address": "Muster AG\nMusterstrasse 15\n8640 Rapperswil",
  "delivery_address_type": 0,
  "delivery_address": "Muster AG\nMusterstrasse 15\n8640 Rapperswil",
  "kb_item_status_id": 3,
  "api_reference": null,
  "viewed_by_client_at": null,
  "kb_terms_of_payment_template_id": null,
  "show_total": true,
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
  "document_nr": "AN-00001",
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
  "is_valid_until": "2019-07-24",
  "contact_address_manual": "UTA Immobilien AG\nStadtturmstrasse 15\n5400 Baden",
  "delivery_address_type": 0,
  "delivery_address_manual": "UTA Immobilien AG\nStadtturmstrasse 15\n5400 Baden",
  "api_reference": null,
  "viewed_by_client_at": null,
  "kb_terms_of_payment_template_id": null,
  "template_slug": "581a8010821e01426b8b456b"
}
```

---

## `DELETE` `/2.0/kb_offer/{quote_id}` — Delete a quote

operationId: `DeleteQuote`

This action permanently deletes a quote. It cannot be undone.

### path Parameters

| Parameter | Type | Description |
|---|---|---|
| quote_id *(required)* | integer <int32> | the id of the quote |

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

## `POST` `/2.0/kb_offer/{quote_id}/issue` — Issue a quote

operationId: `v2IssueQuote`

This action issues a quote. The quote must be in the draft status.

### path Parameters

| Parameter | Type | Description |
|---|---|---|
| quote_id *(required)* | integer <int32> | the id of the quote |

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

## `POST` `/2.0/kb_offer/{quote_id}/revertIssue` — Revert issue a quote

operationId: `v2RevertIssueQuote`

This action reverts a quote to the draft status

### path Parameters

| Parameter | Type | Description |
|---|---|---|
| quote_id *(required)* | integer <int32> | the id of the quote |

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

## `POST` `/2.0/kb_offer/{quote_id}/accept` — Accept a quote

operationId: `v2AcceptQuote`

This action accepts a quote. The value `kb_item_status_id` must be `2` in this case.

### path Parameters

| Parameter | Type | Description |
|---|---|---|
| quote_id *(required)* | integer <int32> | the id of the quote |

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

## `POST` `/2.0/kb_offer/{quote_id}/reject` — Decline a quote

operationId: `v2DeclineQuote`

This action declines a quote. The value `kb_item_status_id` must be `2` in this case.

### path Parameters

| Parameter | Type | Description |
|---|---|---|
| quote_id *(required)* | integer <int32> | the id of the quote |

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

## `POST` `/2.0/kb_offer/{quote_id}/reissue` — Reissue a quote

operationId: `v2ReissueQuote`

This action re-issues a quote. Meaning the status is changed to pending from either accepted or declined.

### path Parameters

| Parameter | Type | Description |
|---|---|---|
| quote_id *(required)* | integer <int32> | the id of the quote |

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

## `POST` `/2.0/kb_offer/{quote_id}/mark_as_sent` — Mark quote as sent

operationId: `v2RMarkAsSentQuote`

This action marks a quote as sent

### path Parameters

| Parameter | Type | Description |
|---|---|---|
| quote_id *(required)* | integer <int32> | the id of the quote |

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

## `GET` `/2.0/kb_offer/{quote_id}/pdf` — Show PDF

operationId: `v2ShowQuotePDF`

This action returns a pdf document of the quote.

### path Parameters

| Parameter | Type | Description |
|---|---|---|
| quote_id *(required)* | integer <int32> | the id of the quote |
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

## `POST` `/2.0/kb_offer/{quote_id}/send` — Send a quote

operationId: `v2SendQuote`

This action sends a quote by email.

### path Parameters

| Parameter | Type | Description |
|---|---|---|
| quote_id *(required)* | integer <int32> | the id of the quote |

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

## `POST` `/2.0/kb_offer/{quote_id}/copy` — Copy a quote

operationId: `v2CopyQuote`

This action copies a quote.

### path Parameters

| Parameter | Type | Description |
|---|---|---|
| quote_id *(required)* | integer <int32> | the id of the quote |

### Request Body schema: application/json

| Parameter | Type | Description |
|---|---|---|
| contact_id *(required)* | integer or null | References a contact object |
| contact_sub_id | integer or null | References a contact object |
| is_valid_from | string <date> |  |
| pr_project_id | integer or null | References a project object |
| title | string or null |  |

### Responses

200, 422

**200** — OK

**Response samples** (200):

```json
{
  "id": 4,
  "document_nr": "AN-00001",
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
  "is_valid_until": "2019-07-24",
  "contact_address": "Muster AG\nMusterstrasse 15\n8640 Rapperswil",
  "delivery_address_type": 0,
  "delivery_address": "Muster AG\nMusterstrasse 15\n8640 Rapperswil",
  "kb_item_status_id": 3,
  "api_reference": null,
  "viewed_by_client_at": null,
  "kb_terms_of_payment_template_id": null,
  "show_total": true,
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
  "contact_id": 14,
  "contact_sub_id": null,
  "is_valid_from": "2019-06-27",
  "pr_project_id": null,
  "title": null
}
```

---

## `POST` `/2.0/kb_offer/{quote_id}/order` — Create order from quote

operationId: `v2CreateOrderFromQuote`

This action creates an order from a quote.

### path Parameters

| Parameter | Type | Description |
|---|---|---|
| quote_id *(required)* | integer <int32> | the id of the quote |

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

## `POST` `/2.0/kb_offer/{quote_id}/invoice` — Create invoice from quote

operationId: `v2CreateInvoiceFromQuote`

This action creates an invoice from a quote.

### path Parameters

| Parameter | Type | Description |
|---|---|---|
| quote_id *(required)* | integer <int32> | the id of the quote |

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
