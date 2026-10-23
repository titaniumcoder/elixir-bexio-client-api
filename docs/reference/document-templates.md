# Document templates

Part of **Sales Order Management**. Extracted from docs.bexio.com (snapshot Mon, 28 Sep 2026 12:05:15 GMT). 1 operations.

| Method | Path | Title |
|---|---|---|
| `GET` | `/3.0/document_templates` | List document templates |

## `GET` `/3.0/document_templates` — List document templates

operationId: `v3ListDocumentTemplate`

This action fetches a list of document templates

### Responses

200

**200** — OK

**Response samples** (200):

```json
[
  {
    "template_slug": "5f118cbc200a0c76ef1f34b2",
    "name": "Standard template",
    "is_default": true,
    "default_for_document_types": [
      "type_offer",
      "type_order",
      "type_invoice",
      "type_delivery",
      "type_credit_voucher",
      "type_account_statement",
      "type_article_order"
    ]
  }
]
```

---
