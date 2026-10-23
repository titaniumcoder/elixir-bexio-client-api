# API Scopes

Scope is a mechanism in OAuth 2.0 / OpenID Connect to limit an application's access to a user's account.
An application can request one or more scopes, this information is then presented to the user in the consent screen,
and the access token issued to the application will be limited to the scopes granted.
Please only request the scopes that you need for your application. You are allowed to request multiple scopes per request.
Multiple scopes have to be separated by a whitespace. As an example, write access to quotes and invoices can be requested
with the following scopes: `kb_offer_edit kb_invoice_edit`.
Read access is granted automatically when a write scope is requested for a resource.
This means that by requesting the scope `contact_edit` the scope `contact_show` is not needed in order to get read access to contacts.
Scope
Description
`accounting`
Write access to accounting data
`article_show`
Read access to items / products
`article_edit`
Write access to items / products
`bank_account_show`
Show bank accounts
`bank_payment_show`
Show bank payments
`bank_payment_edit`
Show and edit bank payments
`contact_show`
Read access to contacts
`contact_edit`
Write access to contacts
`file`
Read and write access to the inbox (file upload)
`kb_invoice_show`
Read access to invoices
`kb_invoice_edit`
Write access to invoices
`kb_offer_show`
Read access to quotes
`kb_offer_edit`
Write access to quotes
`kb_order_show`
Read access to orders
`kb_order_edit`
Write access to orders
`kb_delivery_show`
Read access to deliveries
`kb_delivery_edit`
Write access to deliveries
`monitoring_show`
Read access to timesheets
`monitoring_edit`
Write access to timesheets
`note_show`
Read access to contact notes
`note_edit`
Write access to contact notes
`kb_article_order_show`
Read access to purchase orders
`kb_article_order_edit`
Write access to purchase orders
`project_show`
Read access to projects
`project_edit`
Write access to projects
`stock_edit`
Write access to item stock
`task_show`
Read access to tasks
`task_edit`
Write access to tasks
`kb_bill_show`
Read access to supplier bills
`kb_expense_show`
Read access to Purchase Expenses
`payroll_employee_show`
Read access to Payroll employees
`payroll_employee_edit`
Write access to Payroll employees
`payroll_absence_show`
Read access to Payroll absences
`payroll_absence_edit`
Write access to Payroll absences
`payroll_paystub_show`
Read access to Payroll paystubs
