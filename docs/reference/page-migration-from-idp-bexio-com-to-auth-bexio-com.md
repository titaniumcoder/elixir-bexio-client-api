# Migration from idp.bexio.com to auth.bexio.com

The IdP, currently available at `idp.bexio.com`, is about to be replaced by a new IdP available on `auth.bexio.com`. Like the `idp.bexio.com`, the new solution will implement the OAuth2 protocol with the OpenID connect extension which ensures compatibility for API clients.
During the migration period of six months, both `idp.bexio.com` and `auth.bexio.com` will be available for API clients to initiate the OAuth2 authorization code flow and to issue API access tokens. This will allow API clients to migrate to the new IdP at their own pace.
`idp.bexio.com` will be decommissioned on 31.03.2025.
How to migrate an API client to the new IdP?
Most client applications can migrate to the new IdP by just reconfiguring the URLs to initialize the authorization flow and to issue tokens. Depending on the framework in use, the URLs to change might differ but usually includes one or more of the following URLs:
Endpoint
Old URL
New URL
Issuer
https://idp.bexio.com
https://auth.bexio.com/realms/bexio
OpenID Configuration URL
https://idp.bexio.com/.well-known/openid-configuration
https://auth.bexio.com/realms/bexio/.well-known/openid-configuration
Authorization endpoint
https://idp.bexio.com/authorize
https://auth.bexio.com/realms/bexio/protocol/openid-connect/auth
Token endpoint
https://idp.bexio.com/token
https://auth.bexio.com/realms/bexio/protocol/openid-connect/token
Userinfo endpoint
https://idp.bexio.com/userinfo
https://auth.bexio.com/realms/bexio/protocol/openid-connect/userinfo
JWK endpoint
https://idp.bexio.com/jwk
https://auth.bexio.com/realms/bexio/protocol/openid-connect/certs
Other configuration options like `client_id`, `client_secret` or `scope` do not need to be changed.
Are there any new features for client applications?
From a client perspective, there are some minor improvements that simplify the correct use of id and access tokens:
- Claims in id tokens are aligned with the `/userinfo` endpoint. Id tokens will contain the following claims if the according scope is requested:
- scope: `profile`, claims: `given_name`, `family_name`, `gender`, `locale`
- scope: `email`, claims: `email`, `email_verified`
- In addition, the following scope has been added to request access to company information in id tokens and the `/userinfo` endpoint:
- scope: `company_profile`, claims: `company_id`, `company_name`, `company_user_id`
Are there breaking changes?
The new IdP differs in some of the claims provided by the access and id tokens returned by the `/token` endpoint and in some of the properties provided by the `/userinfo` endpoint. The breaking changes affect the following claims:
- `iss` - This claim identifies the issuer of the token and is currently `"https://idp.bexio.com"`. With the switch to the new IdP the value will change to `"https://auth.bexio.com/realms/bexio"`.
- `sub` - This claim identifies the user who granted the creation of the token. Currently, the claim equals to the user’s email address. The new IdP will instead return a UUID identifying the user within bexio equal to the `login_id` claim.
- If you’re using the `sub` claim to identify the user, consider switching to the `login_id` claim before migrating to `auth.bexio.com`. `login_id` will be identical on both the old and the new IdP for a given user.
- If you’re using the `sub` claim to get access to the user’s email address, consider to use the `email` claim instead. Please note that the claim is only available if the `email` scope has been granted to your client. Alternatively, you can use the `/3.0/users/me endpoint` (docs).
- `locale` - Contains the user’s default locale if the user grants access to the `openid profile` scope and is provided by the `/userinfo` endpoint. `idp.bexio.com` currently uses the non-compliant underscore to separate language code from country code (as in `de_CH`). `auth.bexio.com` will provide the locale in the OIDC compliant format using a hyphen (e.g. `de-CH`).
- `shard_id` - This claim will no longer be available.
Additionally, the following will change with the switch to the new IdP:
- Offline sessions will have an idle timeout of 1 year. An offline session is created if tokens are requested with the `offline_access` scope. The returned refresh token will be valid indefinitely but the associated offline session will be closed if not renewed within 1 year. This effectively means that tokens must be refreshed within 1 year.
- idp.bexio.com supports accepting some parameters to the `/token` endpoint as query parameters in the URL. This behavior is no longer supported in the new IdP and all parameters must be passed in the request body.
- In some cases, you may run into more strict CORS policies after switching to the new IdP. These issues can be mitigated by adding your web origin as a valid redirect URL for your app on https://developer.bexio.com. Redirect URLs will be accepted as valid web origins for requests from the according client.
Do users have to re-authorize my application after the switch?
To answer this question we have to distinguish between two cases:
- Applications using refresh tokens can migrate refresh tokens issued by `idp.bexio.com` to the new IdP by passing the tokens to the refresh token grant type on https://auth.bexio.com/realms/bexio. When the new IdP receives a refresh token issued by `idp.bexio.com`, the according user consent will be imported. This means that users wont be required to re-authorize your application in this case. Keep in mind though that this requires that applications replace refresh tokens with the new refresh tokens provided during the token refresh instead of reusing the refresh token received with the initial call to the token endpoint. Also, tokens have to be refreshed at least once before `idp.bexio.com` is decommissioned on 31.03.2025.
- If refresh tokens are not used, users will be required to give consent to the scope requested by your application again after switching to the new IdP.
