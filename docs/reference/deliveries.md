# Deliveries

Part of **Sales Order Management**. Extracted from docs.bexio.com (snapshot Mon, 28 Sep 2026 12:05:15 GMT). 3 operations.

| Method | Path | Title |
|---|---|---|
| `GET` | `/2.0/kb_delivery` | Fetch a list of deliveries |
| `GET` | `/2.0/kb_delivery/{delivery_id}` | Fetch a delivery |
| `POST` | `/2.0/kb_delivery/{delivery_id}/issue` | Issue a delivery |

## `GET` `/2.0/kb_delivery` — Fetch a list of deliveries

operationId: `v2ListDeliveries`

This action fetches a list of all deliveries

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
    ]
  }
]
```

---

## `GET` `/2.0/kb_delivery/{delivery_id}` — Fetch a delivery

operationId: `v2ShowDelivery`

This action fetches a single delivery

### path Parameters

| Parameter | Type | Description |
|---|---|---|
| delivery_id *(required)* | integer <int32> | the id of the delivery |

### Responses

200

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

---

## `POST` `/2.0/kb_delivery/{delivery_id}/issue` — Issue a delivery

operationId: `v2IssueDelivery`

This action issues a delivery. The delivery must be in the draft status.

### path Parameters

| Parameter | Type | Description |
|---|---|---|
| delivery_id *(required)* | integer <int32> | the id of the delivery |

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
