# Changelog

We will list any changes to the current version of the API here.
Date
Details of changes
2026-06-19
- Required scopes updated for purchase bills, payment and expense endpoints.
2026-05-26
- Deprecated the payroll endpoint Retrieving paystub pdf.
- New endpoint Downloading paystub pdf downloads the document directly.
2025-12-09
- Deprecated the field `address` in the request payloads of affected endpoints; it is still present in responses for backward compatibility. Affected endpoints:
- Create Contact
- Bulk create Contacts
- Edit Contact
- Create Additional Address
- Edit Additional Address
2025-09-19
- Added documentation for the new payment (4.0) endpoints.
- Marked old payment (3.0) endpoints for deprecation.
2025-08-14
- Added documentation for bill outgoing payment edit endpoint.
2025-08-04
- Added the field `annual` to the response body type of the following endpoints:
- Fetch a list of vat periods
- Fetch a vat period
2025-08-04
- Added the field `is_annual_reporting` to the request payload of the following endpoints:
- Create Calendar Year
- Added the same fields to the response body of the following endpoints:
- Create Calendar Year
- Search Calendar Years
- List Calendar Years
- Show Calendar Year
2025-07-08
- Added the fields `street_name`, `house_number` to the request payload of the following endpoints:
- Create Employee
- Update Employee
- Added the same fields to the response body of the following endpoints:
- Create Employee
- Update Employee
- Retrieves all active employees
- Retrieve a single employee on a specific date
- Deprecated the field `street` in the request payloads of affected endpoints; it is still present in responses for backward compatibility.
2025-06-06
- Added the fields `owner_house_number` and `owner_country_code` to the response body of the following endpoints:
- Fetch List of Bank Accounts
- Fetch Single Bank Account
2025-06-04
- Added the fields `street_name`, `house_number`, and `address_addition` to the request payload of the following endpoints:
- Create Contact
- Edit Contact
- Create Additional Address
- Edit Additional Address
- Bulk Create Contacts
- Added the same fields to the response body of the following endpoints:
- Create Contact
- Edit Contact
- Fetch a List of Contacts
- Fetch a Contact
- Search Contacts
- Create Additional Address
- Edit Additional Address
- Fetch a List of Additional Addresses
- Fetch an Additional Address
- Search Additional Addresses
- Bulk Create Contacts
- Deprecated the field `address` in the request payloads of affected endpoints; it is still present in responses for backward compatibility.
2025-06-02
- Added the field `name_addition` to the request payload of the following endpoints:
- Create additional address
- Search additional addresses
- Edit an additional address
- Added the same field to the response body of the following endpoints:
- Fetch a list of additional addresses
- Create additional address
- Search additional addresses
- Fetch an additional address
- Edit an additional address
2025-04-14
- Payroll scopes have been added to the API Scopes section
- Required scopes have been added for all relevant payroll endpoints (there is no change in the required scopes - only the documentation is updated with missing information).
2024-12-17
- Added Payroll API.
2024-11-15
- Added the field `user_id` to the project endpoints response.
- Added the field `user_id` to the project endpoints response.
- Added the field `user_id` to the project endpoints response.
- Added the field `user_id` to the project endpoints response.
- Added the field `user_id` to the project endpoints response.
2024-10-22
- Replaced "API Tokens" section with Personal Access Tokens (PAT).
2024-10-01
- Changed IdP URL from https://idp.bexio.com to https://auth.bexio.com/realms/bexio
- Added new company_profile scope.
2024-08-06
- Added the field `base_currency_id` to the journal endpoint. This field is read only and can not be changed through the API.
- Added the field `currency_factor` to the journal endpoint. This field is read only and can not be changed through the API.
- Added the field `base_currency_amount` to the journal endpoint. This field is read only and can not be changed through the API.
2024-07-15
- Added Update manual entry endpoint.
- Added Delete manual entry endpoint.
- Added Fetch files of manual compound entry endpoint.
- Added Add file to manual compound entry endpoint.
- Added Fetch file of manual compound entry endpoint.
- Added Delete connection between file and manual compound entry endpoint.
2024-07-15
- Updated description of Add file to accounting entry line endpoint to reference only manual_single_entry and manual_group_entry entries .
- Updated description of Fetch file of accounting entry line endpoint to reference only manual_single_entry and manual_group_entry entries .
- Updated description of Delete file of accounting entry line endpoint to reference only manual_single_entry and manual_group_entry entries .
2024-06-14
- Added date and embed query parameter and response fields to the Fetch a list of currencies endpoint.
2024-05-29
- Added date query parameter and response fields to the Fetch exchange rates for currencies endpoint.
2024-02-14
- Removed legacy API documentation.
2023-12-11
- receiver_house_no marked as required for IBAN and QR payments on purchase outgoing payment endpoint.
2023-10-25
- New optional payment street and payment house number fields added to purchase bill endpoints to allow storing of structured payment address.
2023-10-09
- Change in create Purchase Order endpoint - contact_id has to be an integer.
2023-08-28
- Added new tax types to list of taxes and fetch a tax.
2023-08-02
- Purchase scopes have been added to the API Scopes section
- Required scopes have been updated for all relevant purchase endpoints (there is no change in the required scopes - only the documentation is updated with missing information).
2023-05-16
- Updated guide to migrate clients away from the legacy API to cover all possible scenarios.
- Announce 30.11.2023 as the shutdown date of the legacy API.
2023-04-25
- Added rate limiting section that explains RateLimit HTTP headers.
2023-04-13
- `bill_id` has been removed from the documentation for creating and updating QR and IBAN payments as it is unused
2023-01-31
- Draft QR payments can be added to purchase bills in EUR currency
- Outgoing QR payments can be created for purchase bills in EUR currency
2022-10-10
- Changed Edit a work package method from POST to PATCH.
- Deprecated html_text attribute in article endpoints parameters and responses.
- Added maximum limit value 500 in Bills.
- Changed Update a single purchase order method from POST to PUT.
- Line-items now start at position 0 in bill endpoints.
2022-09-21
- Bill status update endpoint - validation rules for booking account updated.
- Expense status update endpoint - validation rules for booking account updated.
2022-08-26
- IS payment endpoints have been removed as only QR payments are valid after 30.09.2022
- ISR payment endpoints have been removed as only QR payments are valid after 30.09.2022
- ISR fields in bank account endpoints have been deprecated as only QR payments are valid after 30.09.2022
- IS/ISR payment types have been removed from bill and outgoing payments endpoints as only QR payments are valid after 30.09.2022
2022-04-19
- Fixed the language of the recipient’s country field in the sales documents.
2022-03-22
- Added optional parameter to attach the invoice PDF directly to the sending email endpoint.
- Added optional parameter to attach the quote PDF directly to the sending email endpoint.
2022-03-08
- Added new restore endpoint which allows to restore archived contacts.
- Added new query parameter to show archived contacts for contact search, list and fetch.
2021-12-02
- Added new support form.
- Implemented delete a contact group endpoint.
2021-10-18
- Corrected the limit for all API endpoints (max limit is enforced to 2000).
- Changed the default limit of GET requests to 500 (instead of 1000).
2021-07-23
- Added the field `ref_uuid` to the report endpoint. This field is read only and can not be changed through the API.
2021-01-08
- Added the field `uuid` to the project endpoints. This field is read only and can not be changed through the API.
2020-12-16
- Adjusted the timesheet endpoints so that it includes the stopwatch information in the attribute `tracking`
2020-12-08
- Added the section purchase that contains bills, expenses and purchase orders. Please note that Purchase APIs for Bills, Expenses and Outgoing Payments are available only for users already using the new purchase module https://www.bexio.com/en-CH/purchase.
- Updated the files endpoints to include all attributes in the response
- Added all search parameters to the Search files endpoint
- Significantly improved the response time of all API endpoints. For some endpoints the average response time is reduced by up to 40%.
2020-11-02
- The documentation for creating a purchase order was updated because the sample payload and response of the request were wrong
2020-09-24
- Added new endpoints to retrieve and edit purchase orders
2020-09-21
- Added new endpoint List document templates to retrieve the list of document templates
- Added the field `template_slug` to the Quotes, Orders and Invoices endpoints
- The field `logopaper_id` used in above mentioned endpoints has been deprecated in favor of the new field `template_slug`
2020-09-09
- Added the field `source_type` to the File Response and Create new file endpoints
- The field `source_id` used in file endpoints has been deprecated in favor of the new field `source_type`.
2020-07-07
- Added new inbox/file endpoints that can be used to retrieve and upload files
2020-07-07
- Added field `qr_invoice_id` to the Fetch an invoice endpoint
- Added field `additional_information` to the QR payment endpoints
2020-06-30
- Added new endpoints to retrieve and create QR invoice payments
2020-06-25
- Added new endpoints to retrieve and edit project milestones
- Added new endpoints to retrieve and edit project work packages
2020-06-10
- Added new endpoint to retrieve permissions of a signed in user
- Added new endpoints to create and retrieve fictional users
2020-06-04
- Added a new section Refresh Token Flow that details the refresh token flow.
- Added a new FAQ entry for the purchase API
- Added a new section Support
2020-05-28
- Added new endpoint to cancel invoices
- Added new endpoint to change issued invoices to draft
- Added new endpoint to search for accounts
- Added search parameter `intern_code` to the Search Items endpoint
- Added search parameter `api_reference` to the Search Invoices endpoint
- Added search parameter `iso_639_1` to the Search Languages endpoint
2020-04-20
- Added 201 response for the endpoint Create IS payment to the documentation.
- Changed the name of the parameter `unique_id` to `instruction_id` in the documentation for all IS payment endpoints (was always returned as `instruction_id` through the API).
2020-04-16
- Added the section API Tokens that details how server-to-server connections without the consent flow can be established.
2020-03-31
- A more detailed description explaining how to retrieve all valid sales taxes from the API has been added to the `tax_id` parameter for line items on quotes, orders and invoices.
2020-02-20
- Fixed 404 access errors for the Accounts and Account Groups endpoints
- Fixed 404 access errors on a handful of `POST` requests (e.g. edit contact, edit invoice, edit project, etc.)
- Fixed issue within the creation of projects when the value of the field `pr_budget_type_amount` was not saved when the field `pr_budget_type_id` was set to the value of `1`
2020-02-05
- Fixed access issues to PDF endpoints for quotes, orders and invoices
- Added the info that the field `bill_id` can not be used for all create payment endpoints
2019-12-16
First version published
Non-breaking changes may be introduced without changing the API version.
These may include additional fields to JSON data structures, optional
parameters to API calls, new features that can be exposed through existing
API calls, or new API calls.
