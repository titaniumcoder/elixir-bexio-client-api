# Bills

Part of **Purchase**. Extracted from docs.bexio.com (snapshot Mon, 28 Sep 2026 12:05:15 GMT). 8 operations.

| Method | Path | Title |
|---|---|---|
| `GET` | `/4.0/purchase/bills` | Get Bills |
| `POST` | `/4.0/purchase/bills` | Create new Bill |
| `GET` | `/4.0/purchase/bills/{id}` | Get Bill |
| `PUT` | `/4.0/purchase/bills/{id}` | Update Bill |
| `DELETE` | `/4.0/purchase/bills/{id}` | Delete Bill |
| `PUT` | `/4.0/purchase/bills/{id}/bookings/{status}` | Update Bill status |
| `POST` | `/4.0/purchase/bills/{id}/actions` | Execute Bill action |
| `GET` | `/4.0/purchase/documentnumbers/bills` | Validate whether document number is available or not |

## `GET` `/4.0/purchase/bills` — Get Bills

operationId: `ApiBillsList_GET`

Endpoint for retrieving Bills

### query Parameters

| Parameter | Type | Description |
|---|---|---|
| limit | integer Default: 100 | Limit the number of results (max is 500) |
| page | integer Default: 1 | current page |
| order | string Default: asc | sorting order |
| sort | string | field to sort by |
| search_term | string | term for which application will look for (minimum 3 signs, maximum 255 signs) |
| fields[] | string Enum: firstname_suffix lastname_company vendor_ref currency_code document_no title | fields for which search will be run (if no 'fields[]' is specified than searching will be done for all allowed fields) |
| status | string Enum: DRAFTS TODO PAID OVERDUE | filter for Bill 'status' (DRAFTS: [DRAFT], TODO: [BOOKED, PARTIALLY_CREATED, CREATED, PARTIALLY_SENT, SENT, PARTIALLY_DOWNLOADED, DOWNLOADED, PARTIALLY_PAID, PARTIALLY_FAILED, FAILED], PAID: [PAID], OVERDUE: [BOOKED, PARTIALLY_CREATED, CREATED, PARTIALLY_SENT, SENT, PARTIALLY_DOWNLOADED, DOWNLOADED, PARTIALLY_PAID, PARTIALLY_FAILED, FAILED]) and for 'onlyOverdue' (DRAFTS: [FALSE], TODOS: [FALSE], PAID: [FALSE], OVERDUE: [TRUE]). Choosing OVERDUE means that only Bills with 'due_date' before now will be shown |
| bill_date_start | string <date> | filter for Bill 'bill_date', the earliest accepted date |
| bill_date_end | string <date> | filter for Bill 'bill_date', the latest accepted date |
| due_date_start | string <date> | filter for Bill 'due_date', the earliest accepted date |
| due_date_end | string <date> | filter for Bill 'due_date', the latest accepted date |
| vendor_ref | string | filter for Bill 'vendor_ref', text containing in field |
| title | string | filter for Bill 'title', text containing in field |
| currency_code | string | filter for Bill 'currency_code', text containing in field |
| pending_amount_min | number <double> | filter for Bill 'pending_amount', the lowest accepted value |
| pending_amount_max | number <double> | filter for Bill 'pending_amount', the greatest accepted value |
| vendor | string | filter for Bill 'vendor', text containing in fields lastname_company and firstname_suffix |
| gross_min | number <double> | filter for Bill 'gross', the lowest accepted value |
| gross_max | number <double> | filter for Bill 'gross', the greatest accepted value |
| net_min | number <double> | filter for Bill 'net', the lowest accepted value |
| net_max | number <double> | filter for Bill 'net', the greatest accepted value |
| document_no | string | filter for Bill 'document_no', text containing in field |
| supplier_id | integer | filter for Bill 'supplier_id' |
| average_exchange_rate_enabled | boolean | indicates whether 'average_exchange_rate_enabled' is enabled, or not |

### Responses

200, 400, 401, 403

**200** — Bill retrieved

**Response samples** (200):

```json
{
  "data": [
    {
      "id": "2af7df09-bf6b-4a6b-840f-142e337e692a",
      "created_at": "2019-03-23T09:53:49+0000",
      "document_no": "NO-1",
      "status": "DRAFT",
      "vendor_ref": "Vendor 1",
      "firstname_suffix": "John",
      "lastname_company": "Doe",
      "vendor": "John Doe",
      "title": "Title 1",
      "currency_code": "CHF",
      "pending_amount": 100.23,
      "net": 0.45,
      "gross": 13.42,
      "bill_date": "2019-02-12",
      "due_date": "2019-03-14",
      "overdue": false,
      "booking_account_ids": [
        10,
        12
      ],
      "attachment_ids": [
        "1cb712f3-652c-4707-9641-2de94f77e07d",
        "ab2b0d50-f3b0-4773-9c65-6606657db25b",
        "34ef8407-094a-419f-b649-789d36b5d145"
      ]
    },
    {
      "id": "99fd6dc2-09cf-4db6-8dfa-2b9b3b9394b1",
      "created_at": "2019-05-23T09:53:49+0000",
      "document_no": "NO-3",
      "status": "BOOKED",
      "vendor_ref": "Vendor 2",
      "firstname_suffix": "James",
      "lastname_company": "Doe",
      "vendor": "James Doe",
      "title": "Title 2",
      "currency_code": "USD",
      "pending_amount": 2.73,
      "net": 0.01,
      "gross": 1.42,
      "bill_date": "2019-04-02",
      "due_date": "2019-05-27",
      "overdue": true,
      "booking_account_ids": [
        12,
        134,
        9
      ],
      "attachment_ids": [
        "1f1ef73d-6b4a-4de5-812c-27f8732be88b",
        "d9d3a328-8c0b-4889-9b15-d3e9abc24df0"
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

## `POST` `/4.0/purchase/bills` — Create new Bill

operationId: `ApiBills_POST`

Endpoint for creating Bill

### Request Body schema: application/json *(required)*

| Parameter | Type | Description |
|---|---|---|
| supplier_id *(required)* | integer <int32> |  |
| vendor_ref | string |  |
| title | string |  |
| contact_partner_id *(required)* | integer <int32> |  |
| bill_date *(required)* | string <date> |  |
| due_date *(required)* | string <date> |  |
| amount_man | number <double> | Required when 'manual_amount' is true. Maximum of 17 digits and maximum of 2 decimal digits. |
| amount_calc | number <double> | Required when 'manual_amount' is false. Maximum of 17 digits and maximum of 2 decimal digits. |
| manual_amount *(required)* | boolean | indicates whether 'amount_man' or 'amount_calc' is required and considered as bill amount |
| currency_code *(required)* | string |  |
| exchange_rate | number <double> | Required when 'currency_code' is different from 'base_currency_code' (taken from settings). Maximum of 5 digits and maximum of 10 decimal digits. |
| base_currency_amount | number <double> | Required when 'currency_code' is different from 'base_currency_code' (taken from settings). Maximum of 17 digits and maximum of 2 decimal digits. |
| item_net *(required)* | boolean | Indicates whether 'amount' in 'line_items' is net or gross. |
| purchase_order_id | integer <int32> |  |
| qr_bill_information | string |  |
| attachment_ids *(required)* | array |  |
| address *(required)* | object | Address |
| line_items *(required)* | array [1 .. 100] items |  |
| discounts *(required)* | array [0 .. 100] items |  |
| payment | object |  |

### Responses

201, 400, 401, 403

**201** — Successful Bill creation

**Response samples** (201):

```json
{
  "id": "64bf865d-988a-496d-a24f-bab2d52e4b4a",
  "document_no": "LR-12345",
  "title": "Bill 42",
  "status": "DRAFT",
  "firstname_suffix": "LeSS",
  "lastname_company": "Organisation",
  "created_at": "2019-02-12T09:53:49",
  "supplier_id": 1323,
  "vendor_ref": "Reference text",
  "contact_partner_id": 647,
  "bill_date": "2019-02-12",
  "due_date": "2019-03-14",
  "pending_amount": 65.23,
  "amount_man": 23.87,
  "amount_calc": 23.9,
  "manual_amount": true,
  "currency_code": "USD",
  "exchange_rate": 2.3455365492,
  "base_currency_code": "USD",
  "item_net": false,
  "split_into_line_items": true,
  "purchase_order_id": 637,
  "base_currency_amount": 75.23,
  "overdue": true,
  "qr_bill_information": "//S1/10/10201409/11/190512/20/1400.000-53/30/106017086/31/180508/32/7.7/40/2:10;0:30",
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
  },
  "line_items": [
    {
      "id": "2d267f64-6b94-4109-818e-c54515837004",
      "position": 0,
      "title": "First line item title",
      "tax_id": 15,
      "tax_calc": 12.89,
      "amount": 56.8,
      "booking_account_id": 16
    },
    {
      "id": "e33ecd04-188e-40b5-92eb-02f9efbf1b1c",
      "position": 1,
      "title": "Second line item title",
      "tax_id": 15,
      "tax_calc": 8.89,
      "amount": 48.8,
      "booking_account_id": 14
    }
  ],
  "discounts": [
    {
      "id": "8b102a32-5bef-462e-a41b-9c00197c26b9",
      "position": 1,
      "amount": 56.8
    }
  ],
  "payment": {
    "type": "IBAN",
    "bank_account_id": 12,
    "fee": "BY_SENDER",
    "execution_date": "2019-03-15",
    "exchange_rate": 2.34553,
    "amount": 3.9,
    "iban": "CH121234567812345678900",
    "name": "LeSS Organisation",
    "address": "1147 Super Street",
    "street": "Super Street",
    "house_no": 1147,
    "postcode": "9999",
    "city": "Tel Aviv",
    "country_code": "CH",
    "message": "This is a message.",
    "booking_text": "Further education.",
    "salary_payment": false,
    "reference_no": "1212345675321984798456",
    "note": "Some note text"
  },
  "attachment_ids": [
    "e84b9fe2-3fe2-4fcf-8c30-298fe16adb14",
    "aa9fc418-f292-49ad-9a35-9869123d1091"
  ]
}
```

**400** — Bad request

**401** — Access token is missing or is invalid

**403** — No access rights

**Request sample**:

```json
{
  "supplier_id": 1323,
  "vendor_ref": "Reference text",
  "title": "Bill 42",
  "contact_partner_id": 647,
  "bill_date": "2019-02-12",
  "due_date": "2019-03-14",
  "amount_man": 23.8,
  "amount_calc": 32.08,
  "manual_amount": true,
  "currency_code": "CHF",
  "exchange_rate": 2.3455347621,
  "base_currency_amount": 212.78,
  "item_net": false,
  "purchase_order_id": 637,
  "qr_bill_information": "//S1/10/10201409/11/190512/20/1400.000-53/30/106017086/31/180508/32/7.7/40/2:10;0:30",
  "address": {
    "title": "Dr.",
    "salutation": "Mr",
    "firstname_suffix": "John",
    "lastname_company": "Newman",
    "address_line": "Mega Street",
    "postcode": "6694",
    "city": "Tel Aviv",
    "country_code": "CH",
    "main_contact_id": 45,
    "contact_address_id": 827,
    "type": "PRIVATE"
  },
  "line_items": [
    {
      "position": 0,
      "title": "First line item title",
      "tax_id": 15,
      "amount": 56.8,
      "booking_account_id": 16
    },
    {
      "position": 1,
      "title": "Second line item title",
      "tax_id": 15,
      "amount": 48.8,
      "booking_account_id": 14
    }
  ],
  "discounts": [
    {
      "position": 1,
      "amount": 56.8
    }
  ],
  "payment": {
    "type": "IBAN",
    "bank_account_id": 12,
    "fee": "BY_SENDER",
    "execution_date": "2019-03-15",
    "exchange_rate": 2.3455394587,
    "amount": 3.9,
    "iban": "CH121234567812345678900",
    "name": "LeSS Organisation",
    "address": "1147 Super Street",
    "street": "Super Street",
    "house_no": 1147,
    "postcode": "9999",
    "city": "Tel Aviv",
    "country_code": "CH",
    "message": "This is a message.",
    "booking_text": "Further education.",
    "salary_payment": false,
    "reference_no": "1212345675321984798456",
    "note": "Some note text"
  },
  "attachment_ids": [
    "e84b9fe2-3fe2-4fcf-8c30-298fe16adb14",
    "aa9fc418-f292-49ad-9a35-9869123d1091"
  ]
}
```

---

## `GET` `/4.0/purchase/bills/{id}` — Get Bill

operationId: `ApiBills_GET`

Endpoint for retrieving Bill by id

### path Parameters

| Parameter | Type | Description |
|---|---|---|
| id *(required)* | string | id of Bill to retrieve |

### Responses

200, 401, 403, 404

**200** — Bill retrieved

**Response samples** (200):

```json
{
  "id": "64bf865d-988a-496d-a24f-bab2d52e4b4a",
  "document_no": "LR-12345",
  "title": "Bill 42",
  "status": "DRAFT",
  "firstname_suffix": "LeSS",
  "lastname_company": "Organisation",
  "created_at": "2019-02-12T09:53:49",
  "supplier_id": 1323,
  "vendor_ref": "Reference text",
  "contact_partner_id": 647,
  "bill_date": "2019-02-12",
  "due_date": "2019-03-14",
  "pending_amount": 65.23,
  "amount_man": 23.87,
  "amount_calc": 23.9,
  "manual_amount": true,
  "currency_code": "USD",
  "exchange_rate": 2.3455365492,
  "base_currency_code": "USD",
  "item_net": false,
  "split_into_line_items": true,
  "purchase_order_id": 637,
  "base_currency_amount": 75.23,
  "overdue": true,
  "qr_bill_information": "//S1/10/10201409/11/190512/20/1400.000-53/30/106017086/31/180508/32/7.7/40/2:10;0:30",
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
  },
  "line_items": [
    {
      "id": "2d267f64-6b94-4109-818e-c54515837004",
      "position": 0,
      "title": "First line item title",
      "tax_id": 15,
      "tax_calc": 12.89,
      "amount": 56.8,
      "booking_account_id": 16
    },
    {
      "id": "e33ecd04-188e-40b5-92eb-02f9efbf1b1c",
      "position": 1,
      "title": "Second line item title",
      "tax_id": 15,
      "tax_calc": 8.89,
      "amount": 48.8,
      "booking_account_id": 14
    }
  ],
  "discounts": [
    {
      "id": "8b102a32-5bef-462e-a41b-9c00197c26b9",
      "position": 1,
      "amount": 56.8
    }
  ],
  "payment": {
    "type": "IBAN",
    "bank_account_id": 12,
    "fee": "BY_SENDER",
    "execution_date": "2019-03-15",
    "exchange_rate": 2.34553,
    "amount": 3.9,
    "iban": "CH121234567812345678900",
    "name": "LeSS Organisation",
    "address": "1147 Super Street",
    "street": "Super Street",
    "house_no": 1147,
    "postcode": "9999",
    "city": "Tel Aviv",
    "country_code": "CH",
    "message": "This is a message.",
    "booking_text": "Further education.",
    "salary_payment": false,
    "reference_no": "1212345675321984798456",
    "note": "Some note text"
  },
  "attachment_ids": [
    "e84b9fe2-3fe2-4fcf-8c30-298fe16adb14",
    "aa9fc418-f292-49ad-9a35-9869123d1091"
  ]
}
```

**401** — Access token is missing or is invalid

**403** — No access rights

**404** — Bill with specified id was not found

---

## `PUT` `/4.0/purchase/bills/{id}` — Update Bill

operationId: `ApiBills_PUT`

Endpoint for updating Bill

### path Parameters

| Parameter | Type | Description |
|---|---|---|
| id *(required)* | string | id of Bill to update |

### Request Body schema: application/json *(required)*

| Parameter | Type | Description |
|---|---|---|
| document_no | string |  |
| title | string |  |
| supplier_id *(required)* | integer <int32> |  |
| vendor_ref | string |  |
| amount_man | number <double> | Required when 'manual_amount' is true. Maximum of 17 digits and maximum of 2 decimal digits. |
| amount_calc | number <double> | Required when 'manual_amount' is false. Maximum of 17 digits and maximum of 2 decimal digits. |
| manual_amount *(required)* | boolean | Indicates whether 'amount_man' or 'amount_calc' is required and considered as bill amount |
| contact_partner_id *(required)* | integer <int32> |  |
| bill_date *(required)* | string <date> |  |
| due_date *(required)* | string <date> |  |
| currency_code *(required)* | string |  |
| exchange_rate | number <double> | Required when 'currency_code' is different from 'base_currency_code' (taken from settings). Maximum of 5 digits and maximum of 10 decimal digits. |
| item_net *(required)* | boolean |  |
| split_into_line_items *(required)* | boolean | Indicates whether Bill has multiple items (true) or single item (false). By items it means 'line_items' and 'discounts'. |
| base_currency_amount | number <double> | Maximum of 17 digits and maximum of 2 decimal digits. |
| attachment_ids *(required)* | array |  |
| address *(required)* | object | Address |
| line_items *(required)* | array [1 .. 100] items | Each of Line Item's 'id' must be unique (no duplicates) and already existing on the Bill or it should be null for creating new Line Item. When 'split_into_line_items' is false then there must be only 1 Line Item. |
| discounts *(required)* | array [0 .. 100] items | Each of Discount's 'id' must be unique (no duplicates) and already existing on the Bill or it should be null for creating new Discount. When 'split_into_line_items' is false then there must 0 Discounts. |
| payment | object |  |

### Responses

200, 400, 401, 403, 404

**200** — Successful Bill update

**Response samples** (200):

```json
{
  "id": "64bf865d-988a-496d-a24f-bab2d52e4b4a",
  "document_no": "LR-12345",
  "title": "Bill 42",
  "status": "DRAFT",
  "firstname_suffix": "LeSS",
  "lastname_company": "Organisation",
  "created_at": "2019-02-12T09:53:49",
  "supplier_id": 1323,
  "vendor_ref": "Reference text",
  "contact_partner_id": 647,
  "bill_date": "2019-02-12",
  "due_date": "2019-03-14",
  "pending_amount": 65.23,
  "amount_man": 23.87,
  "amount_calc": 23.9,
  "manual_amount": true,
  "currency_code": "USD",
  "exchange_rate": 2.3455365492,
  "base_currency_code": "USD",
  "item_net": false,
  "split_into_line_items": true,
  "purchase_order_id": 637,
  "base_currency_amount": 75.23,
  "overdue": true,
  "qr_bill_information": "//S1/10/10201409/11/190512/20/1400.000-53/30/106017086/31/180508/32/7.7/40/2:10;0:30",
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
  },
  "line_items": [
    {
      "id": "2d267f64-6b94-4109-818e-c54515837004",
      "position": 0,
      "title": "First line item title",
      "tax_id": 15,
      "tax_calc": 12.89,
      "amount": 56.8,
      "booking_account_id": 16
    },
    {
      "id": "e33ecd04-188e-40b5-92eb-02f9efbf1b1c",
      "position": 1,
      "title": "Second line item title",
      "tax_id": 15,
      "tax_calc": 8.89,
      "amount": 48.8,
      "booking_account_id": 14
    }
  ],
  "discounts": [
    {
      "id": "8b102a32-5bef-462e-a41b-9c00197c26b9",
      "position": 1,
      "amount": 56.8
    }
  ],
  "payment": {
    "type": "IBAN",
    "bank_account_id": 12,
    "fee": "BY_SENDER",
    "execution_date": "2019-03-15",
    "exchange_rate": 2.34553,
    "amount": 3.9,
    "iban": "CH121234567812345678900",
    "name": "LeSS Organisation",
    "address": "1147 Super Street",
    "street": "Super Street",
    "house_no": 1147,
    "postcode": "9999",
    "city": "Tel Aviv",
    "country_code": "CH",
    "message": "This is a message.",
    "booking_text": "Further education.",
    "salary_payment": false,
    "reference_no": "1212345675321984798456",
    "note": "Some note text"
  },
  "attachment_ids": [
    "e84b9fe2-3fe2-4fcf-8c30-298fe16adb14",
    "aa9fc418-f292-49ad-9a35-9869123d1091"
  ]
}
```

**400** — Bad request

**401** — Access token is missing or is invalid

**403** — No access rights

**404** — Bill with specified id was not found

**Request sample**:

```json
{
  "document_no": "LR-12345",
  "title": "Bill 42",
  "supplier_id": 1323,
  "vendor_ref": "Reference text",
  "contact_partner_id": 647,
  "bill_date": "2019-02-12",
  "due_date": "2019-03-14",
  "amount_man": 23.8,
  "amount_calc": 23.83,
  "manual_amount": true,
  "currency_code": "CHF",
  "exchange_rate": 2.3455354632,
  "item_net": false,
  "split_into_line_items": true,
  "base_currency_amount": 63.23,
  "attachment_ids": [
    "e84b9fe2-3fe2-4fcf-8c30-298fe16adb14",
    "aa9fc418-f292-49ad-9a35-9869123d1091"
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
  },
  "line_items": [
    {
      "id": "25eb990e-1758-4381-a621-ad57e44ad04c",
      "position": 0,
      "title": "First line item title",
      "tax_id": 15,
      "amount": 56.8,
      "booking_account_id": 16
    },
    {
      "id": "c0260c25-5f70-4428-b9e9-2edbf29f88f5",
      "position": 1,
      "title": "Second line item title",
      "tax_id": 15,
      "amount": 48.8,
      "booking_account_id": 14
    }
  ],
  "discounts": [
    {
      "id": "8b102a32-5bef-462e-a41b-9c00197c26b9",
      "position": 1,
      "amount": 56.8
    }
  ],
  "payment": {
    "type": "IBAN",
    "bank_account_id": 12,
    "fee": "BY_RECEIVER",
    "execution_date": "2019-03-15",
    "exchange_rate": 2.3455394678,
    "amount": 3.9,
    "account_no": 12345678125678900,
    "iban": "CH121234567812345678900",
    "name": "LeSS Organisation",
    "address": "1147 Super Street",
    "street": "Super Street",
    "house_no": 1147,
    "postcode": "9999",
    "city": "Tel Aviv",
    "country_code": "CH",
    "message": "This is a message.",
    "booking_text": "Further education.",
    "salary_payment": false,
    "reference_no": "1212345675321984798456",
    "note": "Some note text"
  }
}
```

---

## `DELETE` `/4.0/purchase/bills/{id}` — Delete Bill

operationId: `ApiBills_DELETE`

Endpoint for deleting Bill by id. Bill can be removed when it is in status DRAFT only.

### path Parameters

| Parameter | Type | Description |
|---|---|---|
| id *(required)* | string | id of Bill to delete |

### Responses

204, 401, 403, 404

**204** — Bill deleted

**401** — Access token is missing or is invalid

**Response samples** (401):

```json
{
  "error_code": 401,
  "message": "Invalid access token"
}
```

**403** — No access rights

**404** — Bill with specified id was not found

---

## `PUT` `/4.0/purchase/bills/{id}/bookings/{status}` — Update Bill status

operationId: `ApiBillBookings_PUT`

Changing status to BOOKED
When changing status to BOOKED there are specific validations triggered:
- Bill must be in status DRAFT.
- 'amount_man' is required and must be greater than 0 when 'manual_amount' is true.
- 'amount_calc' is required and must be greater than 0 when 'manual_amount' is false.
- 'exchange_rate' is required and must be greater than 0 when 'currency_code' does not equal 'base_currency_code'.
- 'base_currency_amount' is required and must be greater than 0 when 'currency_code' does not equal 'base_currency_code'.
- 'bill_date' must be in existing Business Year that is not Closed and not Locked.
- 'due_date' must be after or equal to 'bill_date'.
- 'document_no' cannot be blank and must be unique across all existing Bills in status other than DRAFT.
- 'item_net' must be set to 'true' when any of 'line_items' 'tax_id' is one of tax types that is ignoring vat:
- pre_regards_tax_material
- pre_regards_tax_investment
- pre_customs_tax_material
- pre_customs_tax_investment
- 'line_tems' total amount must be greater than 0.
- 'booking_account_id' is required for each 'line_item'. And this Booking Account:
- Cannot be a system asset account (account type ID 3, is_locked true)
- Cannot be a system liability account (account type ID 4, is_locked true) with the exception of account 2201
- Cannot be a system complete account (account type ID 5, is_locked true)
- 'line_item' amount cannot be less or equal to 0 when 'tax_id' is one of types:
- pre_customs_tax_investment
- pre_customs_tax_material
- pre_regards_tax_investment
- pre_regards_tax_material
- 'line_item' 'tax_id' validation:
- when Bill is not subject to Vat then 'tax_id' must be null
- Tax cannot have 'digit' set to one of:
- 415
- 420
- when Bill's Calendar Year has Effective Vat accounting method then Tax type must be one of:
- pre_tax_material
- pre_tax_investment
- pre_customs_tax_investment
- pre_customs_tax_material
- pre_regards_tax_material
- pre_regards_tax_investment
- when Bill's Calendar Year does not have Effective Vat accounting method then 'tax_id' is not required
- when Bill's Calendar Year does not have Effective Vat accounting method then Tax type must be one of:
- pre_regards_tax_material
- pre_regards_tax_investment
- 'discounts' total amount must be less than 'line_items' total amount.
- Each 'discount' amount must be greater than 0.
- 'discounts' must be empty when there is 'line_item' with amount less or equal to 0.
- 'discounts' must be empty when there is 'line_item' with 'tax_id' being one of types rejecting discounts:
- pre_customs_tax_material
- pre_customs_tax_investment
- 'address.lastname_company' cannot be null or empty
Changing status to DRAFT
When changing status to DRAFT there are specific validations triggered:
- Bill must be in status BOOKED.
- 'bill_date' must be in existing Business Year that is not Closed and not Locked.

### path Parameters

| Parameter | Type | Description |
|---|---|---|
| id *(required)* | string | id of Bill to update |
| status *(required)* | string Enum: DRAFT BOOKED | Bill status to update to |

### Responses

200, 400, 401, 403, 404

**200** — Successful Bill update

**Response samples** (200):

```json
{
  "id": "64bf865d-988a-496d-a24f-bab2d52e4b4a",
  "document_no": "LR-12345",
  "title": "Bill 42",
  "status": "DRAFT",
  "firstname_suffix": "LeSS",
  "lastname_company": "Organisation",
  "created_at": "2019-02-12T09:53:49",
  "supplier_id": 1323,
  "vendor_ref": "Reference text",
  "contact_partner_id": 647,
  "bill_date": "2019-02-12",
  "due_date": "2019-03-14",
  "pending_amount": 65.23,
  "amount_man": 23.87,
  "amount_calc": 23.9,
  "manual_amount": true,
  "currency_code": "USD",
  "exchange_rate": 2.3455365492,
  "base_currency_code": "USD",
  "item_net": false,
  "split_into_line_items": true,
  "purchase_order_id": 637,
  "base_currency_amount": 75.23,
  "overdue": true,
  "qr_bill_information": "//S1/10/10201409/11/190512/20/1400.000-53/30/106017086/31/180508/32/7.7/40/2:10;0:30",
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
  },
  "line_items": [
    {
      "id": "2d267f64-6b94-4109-818e-c54515837004",
      "position": 0,
      "title": "First line item title",
      "tax_id": 15,
      "tax_calc": 12.89,
      "amount": 56.8,
      "booking_account_id": 16
    },
    {
      "id": "e33ecd04-188e-40b5-92eb-02f9efbf1b1c",
      "position": 1,
      "title": "Second line item title",
      "tax_id": 15,
      "tax_calc": 8.89,
      "amount": 48.8,
      "booking_account_id": 14
    }
  ],
  "discounts": [
    {
      "id": "8b102a32-5bef-462e-a41b-9c00197c26b9",
      "position": 1,
      "amount": 56.8
    }
  ],
  "payment": {
    "type": "IBAN",
    "bank_account_id": 12,
    "fee": "BY_SENDER",
    "execution_date": "2019-03-15",
    "exchange_rate": 2.34553,
    "amount": 3.9,
    "iban": "CH121234567812345678900",
    "name": "LeSS Organisation",
    "address": "1147 Super Street",
    "street": "Super Street",
    "house_no": 1147,
    "postcode": "9999",
    "city": "Tel Aviv",
    "country_code": "CH",
    "message": "This is a message.",
    "booking_text": "Further education.",
    "salary_payment": false,
    "reference_no": "1212345675321984798456",
    "note": "Some note text"
  },
  "attachment_ids": [
    "e84b9fe2-3fe2-4fcf-8c30-298fe16adb14",
    "aa9fc418-f292-49ad-9a35-9869123d1091"
  ]
}
```

**400** — Bad request

**401** — Access token is missing or is invalid

**403** — No access rights

**404** — Bill with specified id was not found

---

## `POST` `/4.0/purchase/bills/{id}/actions` — Execute Bill action

operationId: `ApiBillActions_POST`

Endpoint for executing actions for Bill

### path Parameters

| Parameter | Type | Description |
|---|---|---|
| id *(required)* | string | Id of a Bill for which action will be executed |

### Request Body schema: application/json

| Parameter | Type | Description |
|---|---|---|
| action *(required)* | string |  |

### Responses

200, 400, 401, 403, 404

**200** — Successful Bill action execution

**Response samples** (200):

```json
{
  "id": "64bf865d-988a-496d-a24f-bab2d52e4b4a",
  "document_no": "LR-12345",
  "title": "Bill 42",
  "status": "DRAFT",
  "firstname_suffix": "LeSS",
  "lastname_company": "Organisation",
  "created_at": "2019-02-12T09:53:49",
  "supplier_id": 1323,
  "vendor_ref": "Reference text",
  "contact_partner_id": 647,
  "bill_date": "2019-02-12",
  "due_date": "2019-03-14",
  "pending_amount": 65.23,
  "amount_man": 23.87,
  "amount_calc": 23.9,
  "manual_amount": true,
  "currency_code": "USD",
  "exchange_rate": 2.3455365492,
  "base_currency_code": "USD",
  "item_net": false,
  "split_into_line_items": true,
  "purchase_order_id": 637,
  "base_currency_amount": 75.23,
  "overdue": true,
  "qr_bill_information": "//S1/10/10201409/11/190512/20/1400.000-53/30/106017086/31/180508/32/7.7/40/2:10;0:30",
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
  },
  "line_items": [
    {
      "id": "2d267f64-6b94-4109-818e-c54515837004",
      "position": 0,
      "title": "First line item title",
      "tax_id": 15,
      "tax_calc": 12.89,
      "amount": 56.8,
      "booking_account_id": 16
    },
    {
      "id": "e33ecd04-188e-40b5-92eb-02f9efbf1b1c",
      "position": 1,
      "title": "Second line item title",
      "tax_id": 15,
      "tax_calc": 8.89,
      "amount": 48.8,
      "booking_account_id": 14
    }
  ],
  "discounts": [
    {
      "id": "8b102a32-5bef-462e-a41b-9c00197c26b9",
      "position": 1,
      "amount": 56.8
    }
  ],
  "payment": {
    "type": "IBAN",
    "bank_account_id": 12,
    "fee": "BY_SENDER",
    "execution_date": "2019-03-15",
    "exchange_rate": 2.34553,
    "amount": 3.9,
    "iban": "CH121234567812345678900",
    "name": "LeSS Organisation",
    "address": "1147 Super Street",
    "street": "Super Street",
    "house_no": 1147,
    "postcode": "9999",
    "city": "Tel Aviv",
    "country_code": "CH",
    "message": "This is a message.",
    "booking_text": "Further education.",
    "salary_payment": false,
    "reference_no": "1212345675321984798456",
    "note": "Some note text"
  },
  "attachment_ids": [
    "e84b9fe2-3fe2-4fcf-8c30-298fe16adb14",
    "aa9fc418-f292-49ad-9a35-9869123d1091"
  ]
}
```

**400** — Bad request

**401** — Access token is missing or is invalid

**403** — No access rights

**404** — Bill with specified id was not found

**Request sample**:

```json
{
  "action": "DUPLICATE"
}
```

---

## `GET` `/4.0/purchase/documentnumbers/bills` — Validate whether document number is available or not

operationId: `ApiPurchaseDocumentNumbers_GET`

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
