# Expenses

Part of **Purchase**. Extracted from docs.bexio.com (snapshot Mon, 28 Sep 2026 12:05:15 GMT). 8 operations.

| Method | Path | Title |
|---|---|---|
| `GET` | `/4.0/expenses` | Get Expenses |
| `POST` | `/4.0/expenses` | Create new Expense |
| `GET` | `/4.0/expenses/{id}` | Get Expense |
| `PUT` | `/4.0/expenses/{id}` | Update Expense |
| `DELETE` | `/4.0/expenses/{id}` | Delete Expense |
| `PUT` | `/4.0/expenses/{id}/bookings/{status}` | Update Expense status |
| `POST` | `/4.0/expenses/{id}/actions` | Execute Expense action |
| `GET` | `/4.0/expenses/documentnumbers` | Validate whether document number is available or not |

## `GET` `/4.0/expenses` — Get Expenses

operationId: `ApiExpensesList_GET`

Endpoint for retrieving Expenses

### query Parameters

| Parameter | Type | Description |
|---|---|---|
| limit | integer Default: 100 | results per page |
| page | integer Default: 1 | current page |
| order | string Default: asc | sorting order |
| sort | string | field to sort by |
| vendor | string | filter for Expense 'vendor', text containing in fields lastname_company and firstname_suffix |
| gross_min | number <double> | filter for Expense 'gross', the lowest accepted value |
| gross_max | number <double> | filter for Expense 'gross', the greatest accepted value |
| net_min | number <double> | filter for Expense 'net', the lowest accepted value |
| net_max | number <double> | filter for Expense 'net', the greatest accepted value |
| paid_on_start | string <date> | filter for Expense 'paid_on', the earliest accepted date |
| paid_on_end | string <date> | filter for Expense 'paid_on', the latest accepted date |
| created_at_start | string <date-time> | filter for Expense 'created_at', the earliest accepted date |
| created_at_end | string <date-time> | filter for Expense 'created_at', the latest accepted date |
| title | string | filter for Expense 'title', text containing in field |
| currency_code | string | filter for Expense 'currency_code', text containing in field |
| document_no | string | filter for Expense 'document_no', text containing in field |
| supplier_id | integer | filter for Expense 'supplier_id' |
| project_id | string | filter for Expense 'project_id' |

### Responses

200, 400, 401, 403

**200** — Expenses retrieved

**Response samples** (200):

```json
{
  "data": [
    {
      "id": "e27be5f4-c8db-4193-92f3-1c6f1dc98f1b",
      "created_at": "2019-03-23T09:53:49+0000",
      "document_no": "NO-1",
      "status": "DRAFT",
      "firstname_suffix": "John",
      "lastname_company": "Doe",
      "vendor": "John Doe",
      "title": "Title 1",
      "currency_code": "CHF",
      "paid_on": "2019-03-07",
      "booking_account_id": 387,
      "net": 26.65,
      "gross": 29.43,
      "project_id": "c14aa91c-b4f5-43ca-ae2a-882f94cd40f4",
      "chargeable_contact_id": 4,
      "transaction_id": "b388a4da-7085-475a-87a0-a2acb4d8d68f",
      "invoice_id": "9d47155f-eac4-491e-96d0-8e187c5a7ab6",
      "attachment_ids": [
        "60dd4dfa-24a3-4114-a934-108380789edc",
        "a3161942-1b1d-42c1-816d-dc44cd53c7e6"
      ]
    },
    {
      "id": "dd6d20f4-8c77-45ba-952f-84948798c79b",
      "created_at": "2019-05-23T09:53:49+0000",
      "document_no": "NO-3",
      "status": "DONE",
      "vendor_ref": "Vendor 2",
      "firstname_suffix": "James",
      "lastname_company": "Doe",
      "vendor": "James Doe",
      "title": "Title 2",
      "currency_code": "USD",
      "paid_on": "2018-02-07",
      "booking_account_id": 7,
      "net": 31.39,
      "gross": 50.44,
      "project_id": "1a1864c0-ba80-46a8-ad89-ffd128db9456",
      "chargeable_contact_id": 7,
      "transaction_id": "771590b0-a794-461f-a375-886e4634b618",
      "invoice_id": "9d47155f-eac4-491e-96d0-8e187c5a7ab6",
      "attachment_ids": [
        "06573f59-01a2-493d-9876-462deda4cee3",
        "a230f087-f742-4259-925e-cf3abea5e6bf"
      ]
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

## `POST` `/4.0/expenses` — Create new Expense

operationId: `ApiExpenses_POST`

Endpoint for creating Expense

### Request Body schema: application/json *(required)*

| Parameter | Type | Description |
|---|---|---|
| paid_on *(required)* | string <date> |  |
| currency_code *(required)* | string |  |
| supplier_id | integer <int32> |  |
| title | string |  |
| bank_account_id | integer <int32> |  |
| booking_account_id | integer <int32> |  |
| amount *(required)* | number <double> | Maximum of 17 digits and maximum of 2 decimal digits. |
| tax_id | integer <int32> |  |
| exchange_rate | number <double> | Required when 'currency_code' is different from 'base_currency_code' (taken from settings). Maximum of 5 digits and maximum of 10 decimal digits. |
| base_currency_amount | number <double> | Required when 'currency_code' is different from 'base_currency_code' (taken from settings). Maximum of 17 digits and maximum of 2 decimal digits. |
| attachment_ids *(required)* | array | List of file ids that should be attached to this Expense. Cannot have duplicates. |
| address | object | Address |

### Responses

201, 400, 401, 403

**201** — Successful Expense creation

**Response samples** (201):

```json
{
  "id": "759b0915-4787-4151-9a81-6e7499d26bee",
  "document_no": "123",
  "title": "Some Title",
  "status": "DRAFT",
  "firstname_suffix": "Less",
  "lastname_company": "Organisation",
  "created_at": "2019-03-23T09:53:49+0000",
  "supplier_id": null,
  "paid_on": "2019-03-20",
  "bank_account_id": 3,
  "booking_account_id": 4,
  "currency_code": "CHF",
  "base_currency_code": "USD",
  "exchange_rate": 1.4123567431,
  "amount": 30.9,
  "tax_man": 1.14,
  "tax_calc": 3.45,
  "tax_id": 6,
  "base_currency_amount": 24.84,
  "transaction_id": null,
  "invoice_id": null,
  "project_id": null,
  "attachment_ids": [
    "3c570a07-1fa1-41e7-a761-0f486dfc01f6",
    "138c5618-744c-4c05-b504-c034ccf5f7d9"
  ],
  "address": {
    "title": "Prof",
    "salutation": "Mrs",
    "firstname_suffix": "John",
    "lastname_company": "Newman",
    "address_line": "Mega Street",
    "postcode": "6694",
    "city": "Tel Aviv",
    "country_code": "CH",
    "main_contact_id": 45,
    "contact_address_id": 827,
    "type": "PRIVATE"
  }
}
```

**400** — Bad request

**401** — Access token is missing or is invalid

**403** — No access rights

**Request sample**:

```json
{
  "paid_on": "2019-03-20",
  "currency_code": "CHF",
  "exchange_rate": 1.5243546497,
  "supplier_id": 123,
  "title": "Expense 42",
  "bank_account_id": 5,
  "booking_account_id": 16,
  "amount": 80.54,
  "tax_id": 15,
  "base_currency_amount": 167.87,
  "attachment_ids": [
    "3c570a07-1fa1-41e7-a761-0f486dfc01f6",
    "138c5618-744c-4c05-b504-c034ccf5f7d9"
  ],
  "address": {
    "title": "Prof",
    "salutation": "Ms",
    "firstname_suffix": "John",
    "lastname_company": "Newman",
    "address_line": "Mega Street",
    "postcode": "6694",
    "city": "Tel Aviv",
    "country_code": "CH",
    "main_contact_id": 45,
    "contact_address_id": 827,
    "type": "PRIVATE"
  }
}
```

---

## `GET` `/4.0/expenses/{id}` — Get Expense

operationId: `ApiExpenses_GET`

Endpoint for retrieving Expense by id

### path Parameters

| Parameter | Type | Description |
|---|---|---|
| id *(required)* | string | id of Expense to retrieve |

### Responses

200, 401, 403, 404

**200** — Expense retrieved

**Response samples** (200):

```json
{
  "id": "1355499f-aa07-4382-887e-acaf0323e6f6",
  "document_no": "123",
  "title": "Some Title",
  "status": "DRAFT",
  "firstname_suffix": "Less",
  "lastname_company": "Organisation",
  "created_at": "2019-03-23T09:53:49+0000",
  "supplier_id": 1,
  "paid_on": "2019-03-20",
  "bank_account_id": 3,
  "booking_account_id": 4,
  "currency_code": "CHF",
  "base_currency_code": "USD",
  "exchange_rate": 1.4355684751,
  "amount": 30.9,
  "tax_man": 1.14,
  "tax_calc": 3.45,
  "tax_id": 6,
  "base_currency_amount": 24.84,
  "transaction_id": "b4229af3-a20f-4f68-b513-db651dd2c2ea",
  "invoice_id": "9d47155f-eac4-491e-96d0-8e187c5a7ab6",
  "project_id": "1a1864c0-ba80-46a8-ad89-ffd128db9456",
  "attachment_ids": [
    "06573f59-01a2-493d-9876-462deda4cee3",
    "a230f087-f742-4259-925e-cf3abea5e6bf"
  ],
  "address": {
    "title": "Prof",
    "salutation": "Mrs",
    "firstname_suffix": "John",
    "lastname_company": "Newman",
    "address_line": "Mega Street",
    "postcode": "6694",
    "city": "Tel Aviv",
    "country_code": "CH",
    "main_contact_id": 45,
    "contact_address_id": 827,
    "type": "PRIVATE"
  }
}
```

**401** — Access token is missing or is invalid

**403** — No access rights

**404** — Expense with specified id was not found

---

## `PUT` `/4.0/expenses/{id}` — Update Expense

operationId: `ApiExpenses_PUT`

Endpoint for updating Expense

### path Parameters

| Parameter | Type | Description |
|---|---|---|
| id *(required)* | string | id of Expense to update |

### Request Body schema: application/json *(required)*

| Parameter | Type | Description |
|---|---|---|
| paid_on *(required)* | string <date> |  |
| currency_code *(required)* | string |  |
| exchange_rate | number <double> | Required when 'currency_code' is different from 'base_currency_code' (taken from settings). Maximum of 5 digits and maximum of 10 decimal digits. |
| supplier_id | integer <int32> |  |
| document_no | string |  |
| title | string |  |
| bank_account_id | integer <int32> |  |
| booking_account_id | integer <int32> |  |
| amount *(required)* | number <double> | Maximum of 17 digits and maximum of 2 decimal digits. |
| tax_id | integer <int32> |  |
| base_currency_amount | number <double> | Maximum of 17 digits and maximum of 2 decimal digits. |
| attachment_ids *(required)* | array | List of file ids that should be attached to this Expense. Cannot have duplicates. |
| address | object | Address |

### Responses

200, 400, 401, 403, 404

**200** — Successful Expense update

**Response samples** (200):

```json
{
  "id": "1355499f-aa07-4382-887e-acaf0323e6f6",
  "document_no": "123",
  "title": "Some Title",
  "status": "DRAFT",
  "firstname_suffix": "Less",
  "lastname_company": "Organisation",
  "created_at": "2019-03-23T09:53:49+0000",
  "supplier_id": 1,
  "paid_on": "2019-03-20",
  "bank_account_id": 3,
  "booking_account_id": 4,
  "currency_code": "CHF",
  "base_currency_code": "USD",
  "exchange_rate": 1.4355684751,
  "amount": 30.9,
  "tax_man": 1.14,
  "tax_calc": 3.45,
  "tax_id": 6,
  "base_currency_amount": 24.84,
  "transaction_id": "b4229af3-a20f-4f68-b513-db651dd2c2ea",
  "invoice_id": "9d47155f-eac4-491e-96d0-8e187c5a7ab6",
  "project_id": "1a1864c0-ba80-46a8-ad89-ffd128db9456",
  "attachment_ids": [
    "06573f59-01a2-493d-9876-462deda4cee3",
    "a230f087-f742-4259-925e-cf3abea5e6bf"
  ],
  "address": {
    "title": "Prof",
    "salutation": "Mrs",
    "firstname_suffix": "John",
    "lastname_company": "Newman",
    "address_line": "Mega Street",
    "postcode": "6694",
    "city": "Tel Aviv",
    "country_code": "CH",
    "main_contact_id": 45,
    "contact_address_id": 827,
    "type": "PRIVATE"
  }
}
```

**400** — Bad request

**401** — Access token is missing or is invalid

**403** — No access rights

**404** — Expense with specified id was not found

**Request sample**:

```json
{
  "currency_code": "CHF",
  "exchange_rate": 1.5497651324,
  "paid_on": "2019-03-20",
  "supplier_id": 123,
  "document_no": "LR-12345",
  "title": "Expense 42",
  "bank_account_id": 5,
  "booking_account_id": 16,
  "amount": 80.54,
  "tax_id": 15,
  "base_currency_amount": 167.87,
  "attachment_ids": [
    "06573f59-01a2-493d-9876-462deda4cee3",
    "a230f087-f742-4259-925e-cf3abea5e6bf"
  ],
  "address": {
    "title": "Prof",
    "salutation": "Ms",
    "firstname_suffix": "John",
    "lastname_company": "Newman",
    "address_line": "Mega Street",
    "postcode": "6694",
    "city": "Tel Aviv",
    "country_code": "CH",
    "main_contact_id": 45,
    "contact_address_id": 827,
    "type": "PRIVATE"
  }
}
```

---

## `DELETE` `/4.0/expenses/{id}` — Delete Expense

operationId: `ApiExpenses_DELETE`

Endpoint for deleting Expense by id. Expense cannot be removed when it is DONE.

### path Parameters

| Parameter | Type | Description |
|---|---|---|
| id *(required)* | string | id of Expense to delete |

### Responses

204, 401, 403, 404

**204** — Expense deleted

**401** — Access token is missing or is invalid

**Response samples** (401):

```json
{
  "error_code": 401,
  "message": "Invalid access token"
}
```

**403** — No access rights

**404** — Expense with specified id was not found

---

## `PUT` `/4.0/expenses/{id}/bookings/{status}` — Update Expense status

operationId: `ApiExpenseBookings_PUT`

Changing status from DRAFT to DONE
When changing status to DONE there are specific validations triggered:
- 'bank_account_id' is required.
- 'base_currency_amount' is required when 'curency_code' does not equal 'base_currency_code' and must be greater than 0.
- 'booking_account_id' is required. And this Booking Account:
- Cannot be a system asset account (account type ID 3, is_locked true)
- Cannot be a system liability account (account type ID 4, is_locked true)
- Cannot be a system complete account (account type ID 5, is_locked true)
- 'document_no' cannot be blank and must be unique across all existing Expenses in DONE status.
- 'exchange_rate' is required when 'curency_code' does not equal 'base_currency_code' and must be greater than 0.
- 'amount' must be greater than 0.
- 'tax_id' validation:
- when Expense is not subject to Vat then 'tax_id' must be null
- Tax cannot have 'digit' set to one of:
- 415
- 420
- when Expense's Calendar Year has Effective Vat accounting method then Tax type must be one of:
- pre_tax_material
- pre_tax_investment
- pre_customs_tax_investment
- pre_customs_tax_material
- pre_regards_tax_material
- pre_regards_tax_investment
- when Expense's Calendar Year does not have Effective Vat accounting method then 'tax_id' is not required
- when Expense's Calendar Year does not have Effective Vat accounting method then Tax type must be one of:
- pre_regards_tax_material
- pre_regards_tax_investment
- 'paid_on' must be in existing Business Year that is not Closed and not Locked.
- If 'supplier_id' is set then 'address' cannot be null.
- If 'aupplier_id' is not set then 'address' must be null.
- If 'address' is set then 'address.lastname_company' cannot be null or empty
Changing status from DONE to DRAFT
When changing status to DRAFT there are specific validations triggered:
- 'paid_on' date must be in existing Business Year that is not Closed and not Locked.
- Expense cannot be linked to an Invoice ('invoice_id' must be null).
- Expense cannot be reconciled with any Transaction ('transaction_id' must be null).

### path Parameters

| Parameter | Type | Description |
|---|---|---|
| id *(required)* | string | Id of Expense to update |
| status *(required)* | string Enum: DRAFT DONE | Expense status to update to |

### Responses

200, 400, 401, 403, 404

**200** — Successful Expense update

**Response samples** (200):

```json
{
  "id": "1355499f-aa07-4382-887e-acaf0323e6f6",
  "document_no": "123",
  "title": "Some Title",
  "status": "DRAFT",
  "firstname_suffix": "Less",
  "lastname_company": "Organisation",
  "created_at": "2019-03-23T09:53:49+0000",
  "supplier_id": 1,
  "paid_on": "2019-03-20",
  "bank_account_id": 3,
  "booking_account_id": 4,
  "currency_code": "CHF",
  "base_currency_code": "USD",
  "exchange_rate": 1.4355684751,
  "amount": 30.9,
  "tax_man": 1.14,
  "tax_calc": 3.45,
  "tax_id": 6,
  "base_currency_amount": 24.84,
  "transaction_id": "b4229af3-a20f-4f68-b513-db651dd2c2ea",
  "invoice_id": "9d47155f-eac4-491e-96d0-8e187c5a7ab6",
  "project_id": "1a1864c0-ba80-46a8-ad89-ffd128db9456",
  "attachment_ids": [
    "06573f59-01a2-493d-9876-462deda4cee3",
    "a230f087-f742-4259-925e-cf3abea5e6bf"
  ],
  "address": {
    "title": "Prof",
    "salutation": "Mrs",
    "firstname_suffix": "John",
    "lastname_company": "Newman",
    "address_line": "Mega Street",
    "postcode": "6694",
    "city": "Tel Aviv",
    "country_code": "CH",
    "main_contact_id": 45,
    "contact_address_id": 827,
    "type": "PRIVATE"
  }
}
```

**400** — Bad request

**401** — Access token is missing or is invalid

**403** — No access rights

**404** — Expense with specified id was not found

---

## `POST` `/4.0/expenses/{id}/actions` — Execute Expense action

operationId: `ApiExpenseActions_POST`

Endpoint for executing actions for Expense

### path Parameters

| Parameter | Type | Description |
|---|---|---|
| id *(required)* | string | id of Expense for which action will be executed |

### Request Body schema: application/json

| Parameter | Type | Description |
|---|---|---|
| action *(required)* | string |  |

### Responses

200, 400, 401, 403, 404

**200** — Successful Expense action execution

**Response samples** (200):

```json
{
  "id": "1355499f-aa07-4382-887e-acaf0323e6f6",
  "document_no": "123",
  "title": "Some Title",
  "status": "DRAFT",
  "firstname_suffix": "Less",
  "lastname_company": "Organisation",
  "created_at": "2019-03-23T09:53:49+0000",
  "supplier_id": 1,
  "paid_on": "2019-03-20",
  "bank_account_id": 3,
  "booking_account_id": 4,
  "currency_code": "CHF",
  "base_currency_code": "USD",
  "exchange_rate": 1.4355684751,
  "amount": 30.9,
  "tax_man": 1.14,
  "tax_calc": 3.45,
  "tax_id": 6,
  "base_currency_amount": 24.84,
  "transaction_id": "b4229af3-a20f-4f68-b513-db651dd2c2ea",
  "invoice_id": "9d47155f-eac4-491e-96d0-8e187c5a7ab6",
  "project_id": "1a1864c0-ba80-46a8-ad89-ffd128db9456",
  "attachment_ids": [
    "06573f59-01a2-493d-9876-462deda4cee3",
    "a230f087-f742-4259-925e-cf3abea5e6bf"
  ],
  "address": {
    "title": "Prof",
    "salutation": "Mrs",
    "firstname_suffix": "John",
    "lastname_company": "Newman",
    "address_line": "Mega Street",
    "postcode": "6694",
    "city": "Tel Aviv",
    "country_code": "CH",
    "main_contact_id": 45,
    "contact_address_id": 827,
    "type": "PRIVATE"
  }
}
```

**400** — Bad request

**401** — Access token is missing or is invalid

**403** — No access rights

**404** — Expense with specified id was not found

**Request sample**:

```json
{
  "action": "DUPLICATE"
}
```

---

## `GET` `/4.0/expenses/documentnumbers` — Validate whether document number is available or not

operationId: `ApiExpenseDocumentNumbers_GET`

Endpoint for retrieving validation for document number

### query Parameters

| Parameter | Type | Description |
|---|---|---|
| document_no *(required)* | string | document number to validate |

### Responses

200, 400, 401, 403

**200** — Document Number validation response

**Response samples** (200):

```json
{
  "valid": false,
  "next_available_no": "AB-1235"
}
```

**400** — Bad request

**401** — Access token is missing or is invalid

**403** — No access rights

---
