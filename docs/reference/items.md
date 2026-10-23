# Items

Part of **Items & Products**. Extracted from docs.bexio.com (snapshot Mon, 28 Sep 2026 12:05:15 GMT). 6 operations.

| Method | Path | Title |
|---|---|---|
| `GET` | `/2.0/article` | Fetch a list of items |
| `POST` | `/2.0/article` | Create item |
| `POST` | `/2.0/article/search` | Search items |
| `GET` | `/2.0/article/{article_id}` | Fetch an item |
| `POST` | `/2.0/article/{article_id}` | Edit an item |
| `DELETE` | `/2.0/article/{article_id}` | Delete an item |

## `GET` `/2.0/article` — Fetch a list of items

operationId: `v2ListItems`

This action fetches a list of all items / products

### query Parameters

| Parameter | Type | Description |
|---|---|---|
| order_by | string Default: id Enum: id intern_name | Defines the order of the results. Multiple sort parameters can be combined by using a comma separator. `_asc` and `_desc` can be appended to any parameter to either sort ascending (default) or descending. |
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
    "user_id": 1,
    "article_type_id": 1,
    "contact_id": 14,
    "deliverer_code": null,
    "deliverer_name": null,
    "deliverer_description": null,
    "intern_code": "wh-2019",
    "intern_name": "Webhosting",
    "intern_description": null,
    "purchase_price": null,
    "sale_price": null,
    "purchase_total": null,
    "sale_total": null,
    "currency_id": null,
    "tax_income_id": null,
    "tax_id": null,
    "tax_expense_id": null,
    "unit_id": null,
    "is_stock": false,
    "stock_id": null,
    "stock_place_id": null,
    "stock_nr": 0,
    "stock_min_nr": 0,
    "stock_reserved_nr": 0,
    "stock_available_nr": 0,
    "stock_picked_nr": 0,
    "stock_disposed_nr": 0,
    "stock_ordered_nr": 0,
    "width": null,
    "height": null,
    "weight": null,
    "volume": null,
    "html_text": null,
    "remarks": null,
    "delivery_price": null,
    "article_group_id": null,
    "account_id": null,
    "expense_account_id": null
  }
]
```

---

## `POST` `/2.0/article` — Create item

operationId: `v2CreateItem`

This action creates a new item

### Request Body schema: application/json *(required)*

| Parameter | Type | Description |
|---|---|---|
| user_id | integer | References a user object (Currently, it has no impact, regardless of which user_id is sent.) |
| article_type_id | integer | Please use the value `1` for physical products or `2` for services |
| contact_id | integer or null | References a contact object |
| deliverer_code | string or null |  |
| deliverer_name | string or null |  |
| deliverer_description | string or null |  |
| intern_code | string |  |
| intern_name | string |  |
| intern_description | string or null |  |
| purchase_price | string or null |  |
| sale_price | string or null |  |
| purchase_total | number or null |  |
| sale_total | number or null |  |
| currency_id | integer or null | References a currency object |
| tax_income_id | integer or null | References a tax object |
| tax_expense_id | integer or null | References a tax object |
| unit_id | integer or null | References a unit object |
| is_stock | boolean | Requires `stock_edit` scope to work. |
| stock_id | integer or null | References a stock location object |
| stock_place_id | integer or null | References a stock area object |
| stock_nr | integer | Please note that the stock number can only be set if no bookings for this product have been made. |
| stock_min_nr | integer |  |
| width | integer or null |  |
| height | integer or null |  |
| weight | integer or null |  |
| volume | integer or null |  |
| html_text *(deprecated)* | string or null |  |
| remarks | string or null |  |
| delivery_price | number or null |  |
| article_group_id | integer or null |  |
| account_id | integer or null | References an account object |
| expense_account_id | integer or null | References an account object |

### Responses

201, 422

**201** — Created

**Response samples** (201):

```json
{
  "id": 4,
  "user_id": 1,
  "article_type_id": 1,
  "contact_id": 14,
  "deliverer_code": null,
  "deliverer_name": null,
  "deliverer_description": null,
  "intern_code": "wh-2019",
  "intern_name": "Webhosting",
  "intern_description": null,
  "purchase_price": null,
  "sale_price": null,
  "purchase_total": null,
  "sale_total": null,
  "currency_id": null,
  "tax_income_id": null,
  "tax_id": null,
  "tax_expense_id": null,
  "unit_id": null,
  "is_stock": false,
  "stock_id": null,
  "stock_place_id": null,
  "stock_nr": 0,
  "stock_min_nr": 0,
  "stock_reserved_nr": 0,
  "stock_available_nr": 0,
  "stock_picked_nr": 0,
  "stock_disposed_nr": 0,
  "stock_ordered_nr": 0,
  "width": null,
  "height": null,
  "weight": null,
  "volume": null,
  "html_text": null,
  "remarks": null,
  "delivery_price": null,
  "article_group_id": null,
  "account_id": null,
  "expense_account_id": null
}
```

**422** — Validation error

**Request sample**:

```json
{
  "user_id": 1,
  "article_type_id": 1,
  "contact_id": 14,
  "deliverer_code": null,
  "deliverer_name": null,
  "deliverer_description": null,
  "intern_code": "wh-2019",
  "intern_name": "Webhosting",
  "intern_description": null,
  "purchase_price": null,
  "sale_price": null,
  "purchase_total": null,
  "sale_total": null,
  "currency_id": null,
  "tax_income_id": null,
  "tax_expense_id": null,
  "unit_id": null,
  "is_stock": false,
  "stock_id": null,
  "stock_place_id": null,
  "stock_nr": 0,
  "stock_min_nr": 0,
  "width": null,
  "height": null,
  "weight": null,
  "volume": null,
  "html_text": null,
  "remarks": null,
  "delivery_price": null,
  "article_group_id": null,
  "account_id": null,
  "expense_account_id": null
}
```

---

## `POST` `/2.0/article/search` — Search items

operationId: `v2SearchItems`

Search items via query. Please refer to the Search section for detailed instructions.
The following search fields are supported:
- `intern_name`
- `intern_code`

### query Parameters

| Parameter | Type | Description |
|---|---|---|
| order_by | string Default: id Enum: id intern_name | Defines the order of the results. Multiple sort parameters can be combined by using a comma separator. `_asc` and `_desc` can be appended to any parameter to either sort ascending (default) or descending. |
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
    "user_id": 1,
    "article_type_id": 1,
    "contact_id": 14,
    "deliverer_code": null,
    "deliverer_name": null,
    "deliverer_description": null,
    "intern_code": "wh-2019",
    "intern_name": "Webhosting",
    "intern_description": null,
    "purchase_price": null,
    "sale_price": null,
    "purchase_total": null,
    "sale_total": null,
    "currency_id": null,
    "tax_income_id": null,
    "tax_id": null,
    "tax_expense_id": null,
    "unit_id": null,
    "is_stock": false,
    "stock_id": null,
    "stock_place_id": null,
    "stock_nr": 0,
    "stock_min_nr": 0,
    "stock_reserved_nr": 0,
    "stock_available_nr": 0,
    "stock_picked_nr": 0,
    "stock_disposed_nr": 0,
    "stock_ordered_nr": 0,
    "width": null,
    "height": null,
    "weight": null,
    "volume": null,
    "html_text": null,
    "remarks": null,
    "delivery_price": null,
    "article_group_id": null,
    "account_id": null,
    "expense_account_id": null
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

## `GET` `/2.0/article/{article_id}` — Fetch an item

operationId: `v2ShowItem`

This action fetches a single item

### path Parameters

| Parameter | Type | Description |
|---|---|---|
| article_id *(required)* | integer <int32> | the id of the item |

### Responses

200

**200** — OK

**Response samples** (200):

```json
{
  "id": 4,
  "user_id": 1,
  "article_type_id": 1,
  "contact_id": 14,
  "deliverer_code": null,
  "deliverer_name": null,
  "deliverer_description": null,
  "intern_code": "wh-2019",
  "intern_name": "Webhosting",
  "intern_description": null,
  "purchase_price": null,
  "sale_price": null,
  "purchase_total": null,
  "sale_total": null,
  "currency_id": null,
  "tax_income_id": null,
  "tax_id": null,
  "tax_expense_id": null,
  "unit_id": null,
  "is_stock": false,
  "stock_id": null,
  "stock_place_id": null,
  "stock_nr": 0,
  "stock_min_nr": 0,
  "stock_reserved_nr": 0,
  "stock_available_nr": 0,
  "stock_picked_nr": 0,
  "stock_disposed_nr": 0,
  "stock_ordered_nr": 0,
  "width": null,
  "height": null,
  "weight": null,
  "volume": null,
  "html_text": null,
  "remarks": null,
  "delivery_price": null,
  "article_group_id": null,
  "account_id": null,
  "expense_account_id": null
}
```

---

## `POST` `/2.0/article/{article_id}` — Edit an item

operationId: `v2EditItem`

This action edits a single item

### path Parameters

| Parameter | Type | Description |
|---|---|---|
| article_id *(required)* | integer <int32> | the id of the item |

### Request Body schema: application/json

| Parameter | Type | Description |
|---|---|---|
| user_id | integer | References a user object (Currently, it has no impact, regardless of which user_id is sent.) |
| contact_id | integer or null | References a contact object |
| deliverer_code | string or null |  |
| deliverer_name | string or null |  |
| deliverer_description | string or null |  |
| intern_code | string |  |
| intern_name | string |  |
| intern_description | string or null |  |
| purchase_price | string or null |  |
| sale_price | string or null |  |
| purchase_total | number or null |  |
| sale_total | number or null |  |
| currency_id | integer or null | References a currency object |
| tax_income_id | integer or null | References a tax object |
| tax_expense_id | integer or null | References a tax object |
| unit_id | integer or null | References a unit object |
| is_stock | boolean | Requires `stock_edit` scope to work. |
| stock_id | integer or null | References a stock location object |
| stock_place_id | integer or null | References a stock area object |
| stock_nr | integer | Please note that the stock number can only be set if no bookings for this product have been made. |
| stock_min_nr | integer |  |
| width | integer or null |  |
| height | integer or null |  |
| weight | integer or null |  |
| volume | integer or null |  |
| html_text *(deprecated)* | string or null |  |
| remarks | string or null |  |
| delivery_price | number or null |  |
| article_group_id | integer or null |  |
| account_id | integer or null | References an account object |
| expense_account_id | integer or null | References an account object |

### Responses

200, 422

**200** — OK

**Response samples** (200):

```json
{
  "id": 4,
  "user_id": 1,
  "article_type_id": 1,
  "contact_id": 14,
  "deliverer_code": null,
  "deliverer_name": null,
  "deliverer_description": null,
  "intern_code": "wh-2019",
  "intern_name": "Webhosting",
  "intern_description": null,
  "purchase_price": null,
  "sale_price": null,
  "purchase_total": null,
  "sale_total": null,
  "currency_id": null,
  "tax_income_id": null,
  "tax_id": null,
  "tax_expense_id": null,
  "unit_id": null,
  "is_stock": false,
  "stock_id": null,
  "stock_place_id": null,
  "stock_nr": 0,
  "stock_min_nr": 0,
  "stock_reserved_nr": 0,
  "stock_available_nr": 0,
  "stock_picked_nr": 0,
  "stock_disposed_nr": 0,
  "stock_ordered_nr": 0,
  "width": null,
  "height": null,
  "weight": null,
  "volume": null,
  "html_text": null,
  "remarks": null,
  "delivery_price": null,
  "article_group_id": null,
  "account_id": null,
  "expense_account_id": null
}
```

**422** — Validation error

**Request sample**:

```json
{
  "user_id": 1,
  "contact_id": 14,
  "deliverer_code": null,
  "deliverer_name": null,
  "deliverer_description": null,
  "intern_code": "wh-2019",
  "intern_name": "Webhosting",
  "intern_description": null,
  "purchase_price": null,
  "sale_price": null,
  "purchase_total": null,
  "sale_total": null,
  "currency_id": null,
  "tax_income_id": null,
  "tax_expense_id": null,
  "unit_id": null,
  "is_stock": false,
  "stock_id": null,
  "stock_place_id": null,
  "stock_nr": 0,
  "stock_min_nr": 0,
  "width": null,
  "height": null,
  "weight": null,
  "volume": null,
  "html_text": null,
  "remarks": null,
  "delivery_price": null,
  "article_group_id": null,
  "account_id": null,
  "expense_account_id": null
}
```

---

## `DELETE` `/2.0/article/{article_id}` — Delete an item

operationId: `DeleteItem`

This action permanently deletes an item. It cannot be undone.

### path Parameters

| Parameter | Type | Description |
|---|---|---|
| article_id *(required)* | integer <int32> | the id of the item |

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
