# Authorization Code Flow

bexio supports the "Authorization Code Grant" as defined in OAuth 2.0 RFC 6749, section 4.1 to obtain an Access Token.
Your app must be server-side because during this exchange, you must also pass along your application's Client Secret, which must always be kept secure, and you will have to store it in your client.
Scopes and user access rights
While connecting via the API there are 2 levels of authorization. One level is the scopes granted to the application using the API. The scopes are granted by the user who sets up the connection to the application. The other level is based on user rights, this is done in the configuration of the user within the bexio UI. The API access happens with the user rights of the user who set up the connection to the application.
Meaning that a user which doesn’t have access to the contact will not have access to the contact via an API connection if the app is given the scope to access contact. A user with access to contacts in the bexio UI will not have access to the contacts if the application doesn’t have the correct scopes granted.
User access \ API client scopes
Client has required scope
Client does not have required scope
User has required permission
✅ API access granted
❌ API access denied
User does not have required permission
❌ API access denied
❌ API access denied
How it works
User
Web App
bexio OpenID Connect
bexio API1. Click on "connect with bexio" link
2. Authorization Code Request to / authorize
3. Redirect to login screen
4. Sign in and give consent
5. Return authorization code
6. Token request
7. Validate token request
8. Return Access & ID token
9. Access bexio API with Access Token
10. Response
- The user clicks Login within the regular web application.
- The web application redirects the user to the `/authorize` endpoint of the bexio OpenID Connect service.
- The bexio OpenID Connect Service displays the login page.
- The user authenticates and sees a consent page listing the permissions bexio will give to the web application.
- The user is redirected back to the web application with an Authorization Code.
- The web application sends this code to the bexio OpenID Connect service (`/token` endpoint) along with the application's Client ID and Client Secret.
- bexio verifies the code, Client ID, and Client Secret.
- An ID Token and Access Token (and optionally, a Refresh Token) is returned to the web application.
- The web application uses the Access Token to call the bexio API.
- The bexio API responds with requested data.
Code example (PHP)
The following example showcases the usage of OpenID Connect (PHP example uses the OpenID-Connect-PHP library).
The library uses OpenID Connect Discovery to automatically configure the application.
``
require __DIR__ . '/vendor/autoload.php';
use Jumbojett\OpenIDConnectClient;
$oidc = new OpenIDConnectClient("https://auth.bexio.com/realms/bexio", "client_id", "client_secret");
$oidc->setRedirectURL("https://www.example.com/oidc_callback");
$oidc->addScope(array("openid", "profile", "contact_show", "offline_access"));
$oidc->authenticate();
echo $oidc->getAccessToken();
``
The consent screen shown to the user will look like this:
