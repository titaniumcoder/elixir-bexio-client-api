# Redirect URL(s)

Redirect URLs are a critical part of the OAuth flow. After a user successfully authorizes an application, the authorization server will redirect the user back to the application with either an authorization code or access token in the URL. Because the redirect URL will contain sensitive information, it is critical that the service doesn’t redirect the user to arbitrary locations.
The best way to ensure the user will only be directed to appropriate locations is to require the developer to register one or more redirect URLs when they create the application.
Source https://www.oauth.com/oauth2-servers/redirect-uris/
The new bexio API platform requires to define redirect URLs during the app registration in the developer portal.
Unknown URLs will not be accepted during the Authorization and the user will receive an error message.
Up to 10 different redirect URLs can be defined for an app, e.g. to support multiple test environments and mobile apps with custom schemes
Please make sure to always use a separate set of Client ID and Client Secret for production environments. You can do this by creating an additional app in the bexio developer portal.
