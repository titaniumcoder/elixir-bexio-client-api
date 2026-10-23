# Company Profile

Part of **Other endpoints**. Extracted from docs.bexio.com (snapshot Mon, 28 Sep 2026 12:05:15 GMT). 2 operations.

| Method | Path | Title |
|---|---|---|
| `GET` | `/2.0/company_profile` | Fetch a list of company profiles |
| `GET` | `/2.0/company_profile/{profile_id}` | Show company profile |

## `GET` `/2.0/company_profile` — Fetch a list of company profiles

operationId: `v2ListCompanyProfile`

Please note that each account currently has only one company profile.

### Responses

200

**200** — OK

**Response samples** (200):

```json
[
  {
    "id": 1,
    "name": "bexio AG",
    "address": "Alte Jonastrasse 24",
    "address_nr": "",
    "postcode": 8640,
    "city": "Rapperswil",
    "country_id": 1,
    "legal_form": "association",
    "country_name": "Switzerland",
    "mail": "info@bexio.com",
    "phone_fixed": "+41 (0)71 552 00 60",
    "phone_mobile": "+41 (0)79 123 45 67",
    "fax": "",
    "url": "https://www.bexio.com",
    "skype_name": "",
    "facebook_name": "",
    "twitter_name": "",
    "description": "",
    "ust_id_nr": "CHE-322.646.985",
    "mwst_nr": "CHE-322.646.985 MWST",
    "trade_register_nr": "",
    "has_own_logo": true,
    "is_public_profile": false,
    "is_logo_public": false,
    "is_address_public": false,
    "is_phone_public": false,
    "is_mobile_public": false,
    "is_fax_public": false,
    "is_mail_public": false,
    "is_url_public": false,
    "is_skype_public": false,
    "logo_base64": "R0lGODlhAQABAIAAAAUEBAAAACwAAAAAAQABAAACAkQBADs="
  }
]
```

---

## `GET` `/2.0/company_profile/{profile_id}` — Show company profile

operationId: `v2ShowCompanyProfile`

This action fetches a single company profile

### path Parameters

| Parameter | Type | Description |
|---|---|---|
| profile_id *(required)* | integer <int32> | the id of the company profile |

### Responses

200

**200** — OK

**Response samples** (200):

```json
{
  "id": 1,
  "name": "bexio AG",
  "address": "Alte Jonastrasse 24",
  "address_nr": "",
  "postcode": 8640,
  "city": "Rapperswil",
  "country_id": 1,
  "legal_form": "association",
  "country_name": "Switzerland",
  "mail": "info@bexio.com",
  "phone_fixed": "+41 (0)71 552 00 60",
  "phone_mobile": "+41 (0)79 123 45 67",
  "fax": "",
  "url": "https://www.bexio.com",
  "skype_name": "",
  "facebook_name": "",
  "twitter_name": "",
  "description": "",
  "ust_id_nr": "CHE-322.646.985",
  "mwst_nr": "CHE-322.646.985 MWST",
  "trade_register_nr": "",
  "has_own_logo": true,
  "is_public_profile": false,
  "is_logo_public": false,
  "is_address_public": false,
  "is_phone_public": false,
  "is_mobile_public": false,
  "is_fax_public": false,
  "is_mail_public": false,
  "is_url_public": false,
  "is_skype_public": false,
  "logo_base64": "R0lGODlhAQABAIAAAAUEBAAAACwAAAAAAQABAAACAkQBADs="
}
```

---
