# OpenID Connect

OpenID Connect 1.0 is a simple identity layer on top of the OAuth 2.0 protocol. It allows Clients to verify the identity
of the End-User based on the authentication performed by an Authorization Server, as well as to obtain basic profile
information about the End-User in an interoperable and REST-like manner.
Key
Value
Issuer
https://auth.bexio.com/realms/bexio
OpenID Configuration URL
https://auth.bexio.com/realms/bexio/.well-known/openid-configuration
Authorization endpoint
https://auth.bexio.com/realms/bexio/protocol/openid-connect/auth
Token endpoint
https://auth.bexio.com/realms/bexio/protocol/openid-connect/token
Userinfo endpoint
https://auth.bexio.com/realms/bexio/protocol/openid-connect/userinfo
JWK endpoint
https://auth.bexio.com/realms/bexio/protocol/openid-connect/certs
If you're using the IdP https://idp.bexio.com for obtaining tokens, please make sure to migrate to https://auth.bexio.com/realms/bexio until 2025-03-31. Afterwards,
https://idp.bexio.com will no longer be available. Refresh tokens issued from https://idp.bexio.com will be valid on https://auth.bexio.com/realms/bexio but must be
exchanged for new refresh tokens until 2025-03-31.
