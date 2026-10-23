# Document Settings

Part of **Sales Order Management**. Extracted from docs.bexio.com (snapshot Mon, 28 Sep 2026 12:05:15 GMT). 1 operations.

| Method | Path | Title |
|---|---|---|
| `GET` | `/2.0/kb_item_setting` | Fetch a list of document settings |

## `GET` `/2.0/kb_item_setting` — Fetch a list of document settings

operationId: `v2ListDocumentSettings`

This action fetches a list of all document settings

### query Parameters

| Parameter | Type | Description |
|---|---|---|
| order_by | string Default: id Enum: id text | Defines the order of the results. Multiple sort parameters can be combined by using a comma separator. `_asc` and `_desc` can be appended to any parameter to either sort ascending (default) or descending. |

### Responses

200

**200** — OK

**Response samples** (200):

```json
[
  {
    "id": 1,
    "text": "Quote",
    "kb_item_class": "KbOffer",
    "enumeration_format": "AN-%nummer%",
    "use_automatic_enumeration": true,
    "use_yearly_enumeration": false,
    "next_nr": 1,
    "nr_min_length": 5,
    "default_time_period_in_days": 14,
    "default_logopaper_id": 1,
    "default_language_id": 1,
    "default_client_bank_account_new_id": 1,
    "default_currency_id": 1,
    "default_mwst_type": 0,
    "default_mwst_is_net": true,
    "default_nb_decimals_amount": 2,
    "default_nb_decimals_price": 2,
    "default_show_position_taxes": false,
    "default_title": "Angebot",
    "default_show_esr_on_same_page": false,
    "default_payment_type_id": 1,
    "kb_terms_of_payment_template_id": 1,
    "default_show_total": true
  }
]
```

---
