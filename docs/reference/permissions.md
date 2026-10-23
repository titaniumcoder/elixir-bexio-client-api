# Permissions

Part of **Other endpoints**. Extracted from docs.bexio.com (snapshot Mon, 28 Sep 2026 12:05:15 GMT). 1 operations.

| Method | Path | Title |
|---|---|---|
| `GET` | `/3.0/permissions` | Get access information of logged in user |

## `GET` `/3.0/permissions` — Get access information of logged in user

operationId: `Permissions`

Get components and user permissions of logged in user

### Responses

200

**200** — OK

**Response samples** (200):

```json
{
  "components": [
    "functionality1",
    "functionality2"
  ],
  "permissions": {
    "property": {
      "attribute1": "enabled",
      "attribute2": "all",
      "attribute3": "all"
    }
  }
}
```

---
