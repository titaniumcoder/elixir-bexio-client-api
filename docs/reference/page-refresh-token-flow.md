# Refresh Token Flow

Web App
bexio OpenID Connect
bexio API1. Exchange Refresh Token for Access Token
2. New Access Token
3. API Request with the new Access Token
4. Response
The scope `offline_access` is required to obtain a refresh token to keep the api connection alive.
- POST a request to the endpoint “/token”. Make sure you use the grant type “refresh_token”. This is implemented according to the standards of OAuth 2.0 RFC 6749
- The response contains a new access token. Please note that the requested scopes do not change when refreshing a token. Acquiring new scopes is only possible by going through the initial authorization process again.
- The new access token can be used to authorize requests and execute API requests
- The bexio API responds with the requested data.
