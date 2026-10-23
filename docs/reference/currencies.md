# Currencies

Part of **Accounting**. Extracted from docs.bexio.com (snapshot Mon, 28 Sep 2026 12:05:15 GMT). 7 operations.

| Method | Path | Title |
|---|---|---|
| `GET` | `/3.0/currencies` | Fetch a list of currencies |
| `POST` | `/3.0/currencies` | Create a currency |
| `GET` | `/3.0/currencies/{currency_id}` | Fetch a currency |
| `DELETE` | `/3.0/currencies/{currency_id}` | Delete a currency |
| `PATCH` | `/3.0/currencies/{currency_id}` | Update a currency |
| `GET` | `/3.0/currencies/{currency_id}/exchange_rates` | Fetch exchange rates for currencies |
| `GET` | `/3.0/currencies/codes` | Fetch all possible currency codes |

## `GET` `/3.0/currencies` — Fetch a list of currencies

operationId: `ListCurrencies`

This action fetches a list of all currencies

### query Parameters

| Parameter | Type | Description |
|---|---|---|
| limit | integer <int32> Default: 500 | Limit the number of results (max is 2000) |
| offset | integer <int32> Default: 0 | Skip over a number of elements by specifying an offset value for the query |
| embed | string | The embed parameters is being used for embedding related resources in the response. Example In case of `embed=exchange_rate` the fields `exchange_rate`, `exchange_rate_id`, `ratio`, `exchange_rate_to_ratio`, `source`, `source_reason` and `exchange_rate_date` are shown |
| date | string <date> | the validity date for the fetched exchange rate |

### Responses

200

**200** — OK

**Response samples** (200):

```json
[
  {
    "id": 1,
    "name": "CHF",
    "round_factor": 0.05,
    "exchange_rate": 0.9849,
    "exchange_rate_id": 2,
    "ratio": 1,
    "exchange_rate_to_ratio": 0.9849,
    "source": "monthly_average",
    "source_reason": "monthly_average_provided",
    "exchange_rate_date": "2024-05-01"
  }
]
```

---

## `POST` `/3.0/currencies` — Create a currency

operationId: `CreateCurrency`

This action creates a new currency

### Request Body schema: application/json *(required)*

| Parameter | Type | Description |
|---|---|---|
| name *(required)* | string | A name of the currency. Must be in the format "ISO 4217" and must be unique. |
| round_factor *(required)* | number | The round factor of the currency. E.g.: In order to round CHF to 5 Rp. the round_factor must be set to 0.05 |

### Responses

201, 422

**201** — Created

**Response samples** (201):

```json
{
  "id": 1,
  "name": "CHF",
  "round_factor": 0.05
}
```

**422** — Validation error

**Request sample**:

```json
{
  "name": "CHF",
  "round_factor": 0.05
}
```

---

## `GET` `/3.0/currencies/{currency_id}` — Fetch a currency

operationId: `ShowCurrency`

This action fetches a single currency

### path Parameters

| Parameter | Type | Description |
|---|---|---|
| currency_id *(required)* | integer <int32> | the id of the currency |

### Responses

200

**200** — OK

**Response samples** (200):

```json
{
  "id": 1,
  "name": "CHF",
  "round_factor": 0.05
}
```

---

## `DELETE` `/3.0/currencies/{currency_id}` — Delete a currency

operationId: `DeleteCurrency`

This action permanently deletes a currency. It cannot be undone.

### path Parameters

| Parameter | Type | Description |
|---|---|---|
| currency_id *(required)* | integer <int32> | the id of the currency |

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

---

## `PATCH` `/3.0/currencies/{currency_id}` — Update a currency

operationId: `UpdateCurrency`

This action updates an existing currency

### path Parameters

| Parameter | Type | Description |
|---|---|---|
| currency_id *(required)* | integer <int32> | the id of the currency |

### Request Body schema: application/json *(required)*

| Parameter | Type | Description |
|---|---|---|
| round_factor | number | The round factor of the currency. E.g.: In order to round CHF to 5 Rp. the round_factor must be set to 0.05 |

### Responses

201, 422

**201** — Created

**Response samples** (201):

```json
{
  "id": 1,
  "name": "CHF",
  "round_factor": 0.05
}
```

**422** — Validation error

**Request sample**:

```json
{
  "round_factor": 0.05
}
```

---

## `GET` `/3.0/currencies/{currency_id}/exchange_rates` — Fetch exchange rates for currencies

operationId: `ListExchangeRatesForCurrency`

This action fetches all configured exchange rates for a given currency

### path Parameters

| Parameter | Type | Description |
|---|---|---|
| currency_id *(required)* | integer <int32> | the id of the currency |

### query Parameters

| Parameter | Type | Description |
|---|---|---|
| date | string <date> | the validity date for the fetched exchange rate |

### Responses

200

**200** — OK

**Response samples** (200):

```json
[
  {
    "factor_nr": 1.2,
    "exchange_currency": {
      "id": 1,
      "name": "CHF",
      "round_factor": 0.05
    },
    "ratio": 1,
    "exchange_rate_to_ratio": 0.9849,
    "source": "monthly_average",
    "source_reason": "monthly_average_provided",
    "exchange_rate_date": "2024-05-01"
  }
]
```

---

## `GET` `/3.0/currencies/codes` — Fetch all possible currency codes

operationId: `ListCurrenciesCodes`

This endpoint can be used to retrieve all available currency codes (in the format CHF, EUR, etc.)

### Responses

200

**200** — OK

**Response samples** (200):

```json
[
  [
    "EUR",
    "GBP",
    "PLN"
  ]
]
```

---
