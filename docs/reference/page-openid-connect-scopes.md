# OpenID Connect Scopes

In addition to scopes controlling API access, the following OpenID Connect Scopes can be used to configure the token response:
Scope
Description
`company_profile`
Adds company specific claims to the id token like `company_id` and `company_name` describing the company the user is signed in to.
`email`
Adds claims containing email address of the signed in user.
`offline_access`
Ensures that tokens can be refreshed also after the current user session has been closed.
`openid`
Standard OpenID Connect (OIDC) scope. Required to indicate that the application intends to use OIDC to verify the user's identity. If requested, an ID token is provided within the token response.
`profile`
Adds user specific claims to the id token like `given_name`, `family_name`, `locale` and `gender`.
