# Payments

Part of **Banking**. Extracted from docs.bexio.com (snapshot Mon, 28 Sep 2026 12:05:15 GMT). 6 operations.

| Method | Path | Title |
|---|---|---|
| `GET` | `/4.0/banking/payments` | Fetch a list of all payments |
| `POST` | `/4.0/banking/payments` | Create a payment |
| `GET` | `/4.0/banking/payments/{payment_id}` | Get a payment |
| `PUT` | `/4.0/banking/payments/{payment_id}` | Update a payment |
| `DELETE` | `/4.0/banking/payments/{payment_id}` | Delete a payment |
| `POST` | `/4.0/banking/payments/{payment_id}/cancel` | Cancel a payment |

## `GET` `/4.0/banking/payments` — Fetch a list of all payments

operationId: `NewFetchAllPayments`

This action returns list of all payments

### query Parameters

| Parameter | Type | Description |
|---|---|---|
| filter-by | string | Filters can be used in range `_`, separated by `;`, example multiple filter - `filter-by=amount:11.16_16.11;execution_date:2025-11-16_2025-12-16` |
| page | integer <int32> Default: 0 | Skip over a number of elements by specifying an offset value for the query |
| per-page | integer <int32> Default: 500 | Limit the number of results (max is 2000) |

### Responses

200

**200** — OK

**Response samples** (200):

```json
{
  "id": 0,
  "uuid": "string",
  "sender": {
    "id": 0,
    "uuid": "string",
    "iban": "string"
  },
  "recipient": {
    "name": "John Doe / John Doe Company Name",
    "iban": "CH3000784295116252003",
    "address": {
      "street_name": "F\u00f6hrenstrasse",
      "house_number": "34",
      "zip": "5003",
      "city": "Z\u00fcrich",
      "country_code": "CH"
    }
  },
  "amount": "10.5858",
  "currency": "CHF",
  "execution_date": "2022-02-01",
  "allowance": "fee_paid_by_payer",
  "is_salary": false,
  "instruction_id": "string",
  "purchase_reference": {
    "bill_id": "50d9b44e-68b6-43d6-9c5e-0cb4e5e0080c",
    "bill_payment_id": "98f2c638-ee51-4159-9c26-27958d8fd6be"
  },
  "document_no": "0000044",
  "qr_reference_number": "RF95000000000000000000011 / CH4431999123000889012",
  "additional_information": "string",
  "status": "open",
  "type": "iban",
  "due_date": "2022-02-01",
  "created_at": "string",
  "is_editing_restricted": false
}
```

---

## `POST` `/4.0/banking/payments` — Create a payment

operationId: `NewCreatePayment`

This action creates a new payment

### Request Body schema: application/json *(required)*

| Parameter | Type | Description |
|---|---|---|
| account_id *(required)* | string |  |
| allowance | string Default: fee_split Enum: fee_paid_by_payer fee_paid_by_payee fee_split no_fee | For payments to other countries or with different currencies |
| amount *(required)* | number | The amount (decimal number) to send in the chosen currency. The amount may be exchanged by the bank if a currency is different from the currency of an account |
| currency *(required)* | string | Currency in which send a payment, according to ISO 4217 |
| execution_date *(required)* | string <date> | Date according to ISO 8601. Execution date of a payment (when the payment should be carried out by the bank), should be at least the next working day |
| is_salary *(required)* | boolean or null Default: False | If it is a salary payment |
| recipient *(required)* | object |  |
| type *(required)* | string Enum: iban qr | Type of the payment. Each payment requires different fields |
| qr_reference_number | string | A QR reference number or creditor reference number. |
| additional_information | string | Additional information on the payment slip |
| purchase_reference | object |  |
| is_editing_restricted | boolean | If set to true, editing will be restricted to the api client id which created the payment |
| message | string or null | Multiline description of the payment |

### Responses

201, 422

**201** — Created

**Response samples** (201):

```json
{
  "id": 0,
  "uuid": "string",
  "sender": {
    "id": 0,
    "uuid": "string",
    "iban": "string"
  },
  "recipient": {
    "name": "John Doe / John Doe Company Name",
    "iban": "CH3000784295116252003",
    "address": {
      "street_name": "F\u00f6hrenstrasse",
      "house_number": "34",
      "zip": "5003",
      "city": "Z\u00fcrich",
      "country_code": "CH"
    }
  },
  "amount": "10.5858",
  "currency": "CHF",
  "execution_date": "2022-02-01",
  "allowance": "fee_paid_by_payer",
  "is_salary": false,
  "instruction_id": "string",
  "purchase_reference": {
    "bill_id": "50d9b44e-68b6-43d6-9c5e-0cb4e5e0080c",
    "bill_payment_id": "98f2c638-ee51-4159-9c26-27958d8fd6be"
  },
  "document_no": "0000044",
  "qr_reference_number": "RF95000000000000000000011 / CH4431999123000889012",
  "additional_information": "string",
  "status": "open",
  "type": "iban",
  "due_date": "2022-02-01",
  "created_at": "string",
  "is_editing_restricted": false
}
```

**422** — Validation error

**Request sample**:

```json
{
  "account_id": "449e7a5c-69d3-4b8a-aaaf-5c9b713ebc65",
  "allowance": "fee_paid_by_payer",
  "amount": "10.5858",
  "currency": "CHF",
  "execution_date": "2025-11-16",
  "is_salary": false,
  "recipient": {
    "name": "John Doe / John Doe Company Name",
    "iban": "CH3000784295116252003",
    "address": {
      "street_name": "F\u00f6hrenstrasse",
      "house_number": "34",
      "zip": "5003",
      "city": "Z\u00fcrich",
      "country_code": "CH"
    }
  },
  "type": "iban",
  "qr_reference_number": "998877000000000000000000634",
  "additional_information": "//S1/10/5541/11/191210/20/1235/31/191220200108/32/2.5:337.5;3.7:3807.5/40/0:30",
  "purchase_reference": {
    "bill_id": "50d9b44e-68b6-43d6-9c5e-0cb4e5e0080c",
    "bill_payment_id": "98f2c638-ee51-4159-9c26-27958d8fd6be"
  },
  "is_editing_restricted": false,
  "message": "string"
}
```

---

## `GET` `/4.0/banking/payments/{payment_id}` — Get a payment

operationId: `NewGetPayment`

This action returns single payment

### path Parameters

| Parameter | Type | Description |
|---|---|---|
| payment_id *(required)* | string | Payment uuid |

### Responses

200

**200** — Success

**Response samples** (200):

```json
{
  "id": 0,
  "uuid": "string",
  "sender": {
    "id": 0,
    "uuid": "string",
    "iban": "string"
  },
  "recipient": {
    "name": "John Doe / John Doe Company Name",
    "iban": "CH3000784295116252003",
    "address": {
      "street_name": "F\u00f6hrenstrasse",
      "house_number": "34",
      "zip": "5003",
      "city": "Z\u00fcrich",
      "country_code": "CH"
    }
  },
  "amount": "10.5858",
  "currency": "CHF",
  "execution_date": "2022-02-01",
  "allowance": "fee_paid_by_payer",
  "is_salary": false,
  "instruction_id": "string",
  "purchase_reference": {
    "bill_id": "50d9b44e-68b6-43d6-9c5e-0cb4e5e0080c",
    "bill_payment_id": "98f2c638-ee51-4159-9c26-27958d8fd6be"
  },
  "document_no": "0000044",
  "qr_reference_number": "RF95000000000000000000011 / CH4431999123000889012",
  "additional_information": "string",
  "status": "open",
  "type": "iban",
  "due_date": "2022-02-01",
  "created_at": "string",
  "is_editing_restricted": false
}
```

---

## `PUT` `/4.0/banking/payments/{payment_id}` — Update a payment

operationId: `NewUpdatePayment`

This action updates a payment

### path Parameters

| Parameter | Type | Description |
|---|---|---|
| payment_id *(required)* | string | Payment uuid |

### Request Body schema: application/json *(required)*

| Parameter | Type | Description |
|---|---|---|
| allowance | string Default: fee_split Enum: fee_paid_by_payer fee_paid_by_payee fee_split no_fee | For payments to other countries or with different currencies |
| amount | number | The amount (decimal number) to send in the chosen currency. The amount may be exchanged by the bank if a currency is different from the currency of an account |
| currency | string | Currency in which send a payment, according to ISO 4217 |
| execution_date | string <date> | Date according to ISO 8601. Execution date of a payment (when the payment should be carried out by the bank), should be at least the next working day |
| is_salary | boolean Default: False | If it is a salary payment |
| recipient | object |  |
| qr_reference_number | string | A QR reference number or creditor reference number. |
| additional_information | string | Additional information on the payment slip |
| is_editing_restricted | boolean | If set to true, editing will be restricted to the api client id which created the payment |
| message | string or null | Multiline description of the payment |

### Responses

200, 422

**200** — Updated

**Response samples** (200):

```json
{
  "id": 0,
  "uuid": "string",
  "sender": {
    "id": 0,
    "uuid": "string",
    "iban": "string"
  },
  "recipient": {
    "name": "John Doe / John Doe Company Name",
    "iban": "CH3000784295116252003",
    "address": {
      "street_name": "F\u00f6hrenstrasse",
      "house_number": "34",
      "zip": "5003",
      "city": "Z\u00fcrich",
      "country_code": "CH"
    }
  },
  "amount": "10.5858",
  "currency": "CHF",
  "execution_date": "2022-02-01",
  "allowance": "fee_paid_by_payer",
  "is_salary": false,
  "instruction_id": "string",
  "purchase_reference": {
    "bill_id": "50d9b44e-68b6-43d6-9c5e-0cb4e5e0080c",
    "bill_payment_id": "98f2c638-ee51-4159-9c26-27958d8fd6be"
  },
  "document_no": "0000044",
  "qr_reference_number": "RF95000000000000000000011 / CH4431999123000889012",
  "additional_information": "string",
  "status": "open",
  "type": "iban",
  "due_date": "2022-02-01",
  "created_at": "string",
  "is_editing_restricted": false
}
```

**422** — Validation error

**Request sample**:

```json
{
  "allowance": "fee_paid_by_payer",
  "amount": "10.5858",
  "currency": "CHF",
  "execution_date": "2025-11-16",
  "is_salary": false,
  "recipient": {
    "name": "John Doe / John Doe Company Name",
    "iban": "CH3000784295116252003",
    "address": {
      "street_name": "F\u00f6hrenstrasse",
      "house_number": "34",
      "zip": "5003",
      "city": "Z\u00fcrich",
      "country_code": "CH"
    }
  },
  "qr_reference_number": "998877000000000000000000634",
  "additional_information": "//S1/10/5541/11/191210/20/1235/31/191220200108/32/2.5:337.5;3.7:3807.5/40/0:30",
  "is_editing_restricted": false,
  "message": "string"
}
```

---

## `DELETE` `/4.0/banking/payments/{payment_id}` — Delete a payment

operationId: `NewDeletePayment`

This action permanently deletes an existing payment. It cannot be undone.

### path Parameters

| Parameter | Type | Description |
|---|---|---|
| payment_id *(required)* | string | Payment uuid |

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

## `POST` `/4.0/banking/payments/{payment_id}/cancel` — Cancel a payment

operationId: `NewCancelPayment`

This action cancels an existing payment. Please note that a payment can only be cancelled when the status is "downloaded", "transferred" or "error".

### path Parameters

| Parameter | Type | Description |
|---|---|---|
| payment_id *(required)* | string | Payment uuid |

### Responses

200

**200** — OK

**Response samples** (200):

```json
{
  "id": 0,
  "uuid": "string",
  "sender": {
    "id": 0,
    "uuid": "string",
    "iban": "string"
  },
  "recipient": {
    "name": "John Doe / John Doe Company Name",
    "iban": "CH3000784295116252003",
    "address": {
      "street_name": "F\u00f6hrenstrasse",
      "house_number": "34",
      "zip": "5003",
      "city": "Z\u00fcrich",
      "country_code": "CH"
    }
  },
  "amount": "10.5858",
  "currency": "CHF",
  "execution_date": "2022-02-01",
  "allowance": "fee_paid_by_payer",
  "is_salary": false,
  "instruction_id": "string",
  "purchase_reference": {
    "bill_id": "50d9b44e-68b6-43d6-9c5e-0cb4e5e0080c",
    "bill_payment_id": "98f2c638-ee51-4159-9c26-27958d8fd6be"
  },
  "document_no": "0000044",
  "qr_reference_number": "RF95000000000000000000011 / CH4431999123000889012",
  "additional_information": "string",
  "status": "open",
  "type": "iban",
  "due_date": "2022-02-01",
  "created_at": "string",
  "is_editing_restricted": false
}
```

---
