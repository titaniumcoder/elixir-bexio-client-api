# Outgoing Payment

Part of **Purchase**. Extracted from docs.bexio.com (snapshot Mon, 28 Sep 2026 12:05:15 GMT). 5 operations.

| Method | Path | Title |
|---|---|---|
| `GET` | `/4.0/purchase/outgoing-payments` | Retrieve Outgoing Payments |
| `PUT` | `/4.0/purchase/outgoing-payments` | Edit Outgoing Payment |
| `POST` | `/4.0/purchase/outgoing-payments` | Create new Outgoing Payment |
| `GET` | `/4.0/purchase/outgoing-payments/{id}` | Get Outgoing Payment |
| `DELETE` | `/4.0/purchase/outgoing-payments/{id}` | Delete Outgoing Payment |

## `GET` `/4.0/purchase/outgoing-payments` — Retrieve Outgoing Payments

operationId: `ApiOutgoingPaymentList_GET`

id of Bill for which Outgoing Payments were created

### query Parameters

| Parameter | Type | Description |
|---|---|---|
| bill_id *(required)* | string | id of Bill for which Outgoing Payments were created |
| limit | integer Default: 100 | results per page |
| page | integer Default: 1 | current page |
| order | string Default: asc Enum: asc desc | sorting order |
| sort | string | field to sort by |

### Responses

200, 400, 401, 403

**200** — Outgoing Payments retrieved

**Response samples** (200):

```json
{
  "data": [
    {
      "id": "46913fdc-802b-49ba-99d7-4ccc13cccfc2",
      "bill_id": "176a1442-d66d-4907-b8c8-6dad090452a8",
      "payment_type": "MANUAL",
      "execution_date": "2019-10-15",
      "status": "TRANSFERRED",
      "amount": 45.98,
      "sender_bank_account_id": 4,
      "receiver_account_no": "657858734587301523",
      "receiver_iban": "DE121234567812345678900",
      "banking_payment_id": "0c8b18af-9a66-4c89-b01a-8abab642d69a",
      "transaction_id": "f020b371-939e-427a-8175-eceb8dea17b3"
    },
    {
      "id": "176a1442-d66d-4907-b8c8-6dad090452a8",
      "bill_id": "869f16ee-d688-476b-9f18-9bb608fdc21f",
      "payment_type": "IBAN",
      "status": "PENDING",
      "execution_date": "2019-09-25",
      "amount": 95.2,
      "sender_bank_account_id": 96,
      "receiver_account_no": "253458734587301523",
      "receiver_iban": "ES121234567812345678900",
      "banking_payment_id": "f7e53b5e-a496-4bce-94b5-97f739dc4d5b",
      "transaction_id": "b3bafed8-fe0f-414d-b360-b50734fb199c"
    }
  ],
  "paging": {
    "page": 1,
    "page_size": 10,
    "page_count": 50,
    "item_count": 300
  }
}
```

**400** — Bad request

**401** — Access token is missing or is invalid

**403** — No access rights

---

## `PUT` `/4.0/purchase/outgoing-payments` — Edit Outgoing Payment

operationId: `ApiOutgoingPayment_PUT`

Endpoint for editing Outgoing Payment

### Request Body schema: application/json *(required)*

| Parameter | Type | Description |
|---|---|---|
| payment_id *(required)* | string |  |
| execution_date *(required)* | string <date> | Must be after or equal to Bill's 'bill_date'. Cannot be in CLOSED or LOCKED Business Year. Must be in existing Business Year. For IBAN and QR must be in present or future and cannot be on the weekend. |
| amount *(required)* | number <double> | Must be less or equal to Bill's 'pending_amount'. Maximum of 17 digits and maximum of 2 decimal digits. |
| fee_type | string Enum: BY_SENDER BY_RECEIVER BREAKDOWN NO_FEE | Required for IBAN. Not allowed for QR, MANUAL, CASH_DISCOUNT. Must be set to NO_FEE when 'receiver_iban' is a domestic IBAN (same country as 'sender_bank_account_id' Bank Account IBAN country). Cannot be set to NO_FEE when 'receiver_iban' is not a domestic IBAN. |
| is_salary_payment *(required)* | boolean | Allowed to be set to true only for IBAN. |
| reference_no | string | Not allowed for IBAN, MANUAL, CASH_DISCOUNT. For QR, when 'receiver_iban' is QR Iban then 'reference_no' must be valid Isr Account number. For QR, when 'receiver_iban' is not QR Iban then 'reference_no' must be valid Creditor Reference. |
| message | string | Not allowed for QR, MANUAL, CASH_DISCOUNT. |
| receiver_iban | string | Required for IBAN, QR. Not allowed for MANUAL, CASH_DISCOUNT. Must be valid Iban for IBAN Payment or must be valid QR Iban for QR Payment. |
| receiver_name | string | Required for IBAN, QR. Not allowed for MANUAL, CASH_DISCOUNT. |
| receiver_street | string | Required for IBAN, QR. Not allowed for MANUAL, CASH_DISCOUNT. |
| receiver_house_no | string | Required for IBAN, QR. Not allowed for MANUAL, CASH_DISCOUNT. |
| receiver_city | string | Required for IBAN, QR. Not allowed for MANUAL, CASH_DISCOUNT. |
| receiver_postcode | string | Required for IBAN, QR. Not allowed for MANUAL, CASH_DISCOUNT. |
| receiver_country_code | string |  |

### Responses

200, 400, 401, 403, 404

**200** — Outgoing Payment updated

**Response samples** (200):

```json
{
  "id": "f68e87e0-fa2d-4576-91c6-15f7b6876003",
  "status": "DOWNLOADED",
  "created_at": "2019-06-27T10:25:50+0200",
  "bill_id": "22c306ad-c158-4792-b557-72340df816f5",
  "payment_type": "IBAN",
  "execution_date": "2019-10-15",
  "amount": 45.98,
  "currency_code": "CHF",
  "exchange_rate": 1.0000000032,
  "note": "Some notes",
  "sender_bank_account_id": 2,
  "sender_iban": "DE684734567812345678900",
  "sender_name": "Sender name",
  "sender_street": "Good Street",
  "sender_house_no": "45",
  "sender_city": "Warsaw",
  "sender_postcode": "6723",
  "sender_country_code": "PL",
  "sender_bc_no": "238747349095789",
  "sender_bank_no": "80759758235723820983",
  "sender_bank_name": "Name of the Bank",
  "receiver_iban": "CH121234567812345678900",
  "receiver_name": "Receiver name",
  "receiver_street": "Mega street",
  "receiver_house_no": "10/20",
  "receiver_city": "London",
  "receiver_postcode": "3781",
  "receiver_country_code": "CH",
  "receiver_bc_no": "98364949095789",
  "receiver_bank_no": "26597585382673",
  "receiver_bank_name": "Some Bank name",
  "fee_type": "BREAKDOWN",
  "is_salary_payment": false,
  "reference_no": "9568345675321984798456",
  "message": "Some message",
  "booking_text": "Swimming lessons",
  "banking_payment_id": "f35d39a3-dfc4-43d1-bf38-387f821c0ed0",
  "banking_payment_entry_id": "27c0d66a-8ea2-4b51-9ce0-372d3e0a4117",
  "transaction_id": "b4f1e277-8424-48a7-a0b0-100646e82d25"
}
```

**400** — Bad request

**401** — Access token is missing or is invalid

**403** — No access rights

**404** — Outgoing Payment with specified id was not found

**Request sample**:

```json
{
  "payment_id": "1701eb40-d4ea-4617-a8e0-e40e68cbc1d8",
  "execution_date": "2025-06-12",
  "amount": 100,
  "fee_type": "BY_SENDER",
  "is_salary_payment": false,
  "reference_no": null,
  "message": null,
  "receiver_iban": "NL40INGB5940297536",
  "receiver_name": "Vare Back",
  "receiver_street": "Kniestrasse",
  "receiver_house_no": "1437223",
  "receiver_city": "Jona",
  "receiver_postcode": "8645",
  "receiver_country_code": "CH"
}
```

---

## `POST` `/4.0/purchase/outgoing-payments` — Create new Outgoing Payment

operationId: `ApiOutgoingPayment_POST`

Endpoint for creating Outgoing Payment

### Request Body schema: application/json

| Parameter | Type | Description |
|---|---|---|
| bill_id *(required)* | string | Payment can be created only for Bill that is not in status DRAFT. |
| payment_type *(required)* | string Enum: IBAN MANUAL CASH_DISCOUNT QR | Bill's amount cannot be covered only by CASH_DISCOUNT payments. |
| execution_date *(required)* | string <date> | Must be after or equal to Bill's 'bill_date'. Cannot be in CLOSED or LOCKED Business Year. Must be in existing Business Year. For IBAN and QR must be in present or future and cannot be on the weekend. |
| amount *(required)* | number <double> | Must be less or equal to Bill's 'pending_amount'. Maximum of 17 digits and maximum of 2 decimal digits. |
| currency_code *(required)* | string | Must be equal to Bill's 'currency_code'. Only 'CHF' and 'EUR' is allowed for QR. |
| exchange_rate *(required)* | number <double> | Maximum of 5 digits and maximum of 10 decimal digits. |
| note | string | Not allowed for IBAN, QR. |
| sender_bank_account_id *(required)* | integer <int32> | Required for IBAN, MANUAL, QR. Not allowed for CASH_DISCOUNT. For [IBAN, QR] it must be Bank Account with type 'bank'. For MANUAL it could be Bank Account with type 'bank' or 'cash'. |
| sender_iban | string | Required for IBAN, QR. Not allowed for CASH_DISCOUNT. |
| sender_name | string | Required for IBAN, QR. Not allowed for CASH_DISCOUNT. |
| sender_street | string | Required for IBAN, QR. Not allowed for CASH_DISCOUNT. |
| sender_house_no | string | Not allowed for CASH_DISCOUNT. |
| sender_city | string | Required for IBAN, QR. Not allowed for CASH_DISCOUNT. |
| sender_postcode | string | Required for IBAN, QR. Not allowed for CASH_DISCOUNT. |
| sender_country_code | string | Not allowed for CASH_DISCOUNT. |
| sender_bc_no | string | Not allowed for CASH_DISCOUNT. |
| sender_bank_no | string | Not allowed for CASH_DISCOUNT. |
| sender_bank_name | string | Not allowed for CASH_DISCOUNT. |
| receiver_account_no *(deprecated)* | string | Not allowed for IBAN, QR, MANUAL, CASH_DISCOUNT. |
| receiver_iban | string | Required for IBAN, QR. Not allowed for MANUAL, CASH_DISCOUNT. Must be valid Iban for IBAN Payment or must be valid QR Iban for QR Payment. |
| receiver_name | string | Required for IBAN, QR. Not allowed for MANUAL, CASH_DISCOUNT. |
| receiver_street | string | Required for IBAN, QR. Not allowed for MANUAL, CASH_DISCOUNT. |
| receiver_house_no | string | Required for IBAN, QR. Not allowed for MANUAL, CASH_DISCOUNT. |
| receiver_city | string | Required for IBAN, QR. Not allowed for MANUAL, CASH_DISCOUNT. |
| receiver_postcode | string | Required for IBAN, QR. Not allowed for MANUAL, CASH_DISCOUNT. |
| receiver_country_code | string | Required for IBAN, QR. Not allowed for MANUAL, CASH_DISCOUNT. |
| receiver_bc_no | string | Not allowed for MANUAL, CASH_DISCOUNT. |
| receiver_bank_no | string | Not allowed for MANUAL, CASH_DISCOUNT. |
| receiver_bank_name | string | Not allowed for MANUAL, CASH_DISCOUNT. |
| fee_type | string Enum: BY_SENDER BY_RECEIVER BREAKDOWN NO_FEE | Required for IBAN. Not allowed for QR, MANUAL, CASH_DISCOUNT. Must be set to NO_FEE when 'receiver_iban' is a domestic IBAN (same country as 'sender_bank_account_id' Bank Account IBAN country). Cannot be set to NO_FEE when 'receiver_iban' is not a domestic IBAN. |
| is_salary_payment *(required)* | boolean | Allowed to be set to true only for IBAN. |
| reference_no | string | Not allowed for IBAN, MANUAL, CASH_DISCOUNT. For QR, when 'receiver_iban' is QR Iban then 'reference_no' must be valid Isr Account number. For QR, when 'receiver_iban' is not QR Iban then 'reference_no' must be valid Creaditor Reference. |
| message | string | Not allowed for QR, MANUAL, CASH_DISCOUNT. |
| booking_text | string | Not allowed for MANUAL, CASH_DISCOUNT. |

### Responses

201, 400, 401, 403

**201** — Successful Outgoing Payment creation

**Response samples** (201):

```json
{
  "id": "f68e87e0-fa2d-4576-91c6-15f7b6876003",
  "status": "DOWNLOADED",
  "created_at": "2019-06-27T10:25:50+0200",
  "bill_id": "22c306ad-c158-4792-b557-72340df816f5",
  "payment_type": "IBAN",
  "execution_date": "2019-10-15",
  "amount": 45.98,
  "currency_code": "CHF",
  "exchange_rate": 1.0000000032,
  "note": "Some notes",
  "sender_bank_account_id": 2,
  "sender_iban": "DE684734567812345678900",
  "sender_name": "Sender name",
  "sender_street": "Good Street",
  "sender_house_no": "45",
  "sender_city": "Warsaw",
  "sender_postcode": "6723",
  "sender_country_code": "PL",
  "sender_bc_no": "238747349095789",
  "sender_bank_no": "80759758235723820983",
  "sender_bank_name": "Name of the Bank",
  "receiver_iban": "CH121234567812345678900",
  "receiver_name": "Receiver name",
  "receiver_street": "Mega street",
  "receiver_house_no": "10/20",
  "receiver_city": "London",
  "receiver_postcode": "3781",
  "receiver_country_code": "CH",
  "receiver_bc_no": "98364949095789",
  "receiver_bank_no": "26597585382673",
  "receiver_bank_name": "Some Bank name",
  "fee_type": "BREAKDOWN",
  "is_salary_payment": false,
  "reference_no": "9568345675321984798456",
  "message": "Some message",
  "booking_text": "Swimming lessons",
  "banking_payment_id": "f35d39a3-dfc4-43d1-bf38-387f821c0ed0",
  "banking_payment_entry_id": "27c0d66a-8ea2-4b51-9ce0-372d3e0a4117",
  "transaction_id": "b4f1e277-8424-48a7-a0b0-100646e82d25"
}
```

**400** — Bad request

**401** — Access token is missing or is invalid

**403** — No access rights

**Request sample**:

```json
{
  "bill_id": "13e24b2d-355a-424f-9c80-f457c7ddd555",
  "payment_type": "IBAN",
  "execution_date": "2020-11-13",
  "amount": 78.64,
  "currency_code": "EUR",
  "exchange_rate": 1.211,
  "is_salary_payment": true,
  "fee_type": "BY_SENDER",
  "sender_bank_account_id": 2,
  "sender_iban": "CH5604835012345678009",
  "sender_name": "Muster Hans",
  "sender_city": "London",
  "sender_postcode": "6723",
  "sender_street": "address no 2",
  "receiver_iban": "DE91100000000123456789",
  "receiver_name": "bexio ag",
  "receiver_street": "Reinluftweg 1",
  "receiver_city": "Wattwil",
  "receiver_postcode": "9630",
  "receiver_country_code": "CH"
}
```

---

## `GET` `/4.0/purchase/outgoing-payments/{id}` — Get Outgoing Payment

operationId: `ApiOutgoingPayment_GET`

Endpoint for retrieving Outgoing Payment by id

### path Parameters

| Parameter | Type | Description |
|---|---|---|
| id *(required)* | string | id of Outgoing Payment to retrieve |

### Responses

200, 401, 403, 404

**200** — Outgoing Payment retrieved

**Response samples** (200):

```json
{
  "id": "f68e87e0-fa2d-4576-91c6-15f7b6876003",
  "status": "DOWNLOADED",
  "created_at": "2019-06-27T10:25:50+0200",
  "bill_id": "22c306ad-c158-4792-b557-72340df816f5",
  "payment_type": "IBAN",
  "execution_date": "2019-10-15",
  "amount": 45.98,
  "currency_code": "CHF",
  "exchange_rate": 1.0000000032,
  "note": "Some notes",
  "sender_bank_account_id": 2,
  "sender_iban": "DE684734567812345678900",
  "sender_name": "Sender name",
  "sender_street": "Good Street",
  "sender_house_no": "45",
  "sender_city": "Warsaw",
  "sender_postcode": "6723",
  "sender_country_code": "PL",
  "sender_bc_no": "238747349095789",
  "sender_bank_no": "80759758235723820983",
  "sender_bank_name": "Name of the Bank",
  "receiver_iban": "CH121234567812345678900",
  "receiver_name": "Receiver name",
  "receiver_street": "Mega street",
  "receiver_house_no": "10/20",
  "receiver_city": "London",
  "receiver_postcode": "3781",
  "receiver_country_code": "CH",
  "receiver_bc_no": "98364949095789",
  "receiver_bank_no": "26597585382673",
  "receiver_bank_name": "Some Bank name",
  "fee_type": "BREAKDOWN",
  "is_salary_payment": false,
  "reference_no": "9568345675321984798456",
  "message": "Some message",
  "booking_text": "Swimming lessons",
  "banking_payment_id": "f35d39a3-dfc4-43d1-bf38-387f821c0ed0",
  "banking_payment_entry_id": "27c0d66a-8ea2-4b51-9ce0-372d3e0a4117",
  "transaction_id": "b4f1e277-8424-48a7-a0b0-100646e82d25"
}
```

**401** — Access token is missing or is invalid

**403** — No access rights

**404** — Outgoing Payment with specified id was not found

---

## `DELETE` `/4.0/purchase/outgoing-payments/{id}` — Delete Outgoing Payment

operationId: `ApiOutgoingPayment_DELETE`

Payment cannot be removed when it is RECONCILED (transaction_id is not null). Payment cannot be removed when it's Business Year is Closed or Locked.

### path Parameters

| Parameter | Type | Description |
|---|---|---|
| id *(required)* | string | Outgoing Payment id |

### Responses

204, 400, 401, 403, 404

**204** — Outgoing Payment deleted

**400** — Bad request

**Response samples** (400):

```json
{
  "error_code": 400,
  "message": "Parameters are invalid"
}
```

**401** — Access token is missing or is invalid

**403** — No access rights

**404** — Outgoing Payment with specified id was not found

---
