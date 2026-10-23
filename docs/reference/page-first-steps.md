# First steps

In order to use the bexio API, you need to follow the following steps in order:
- Create a bexio account by signing up for a trial account at https://www.bexio.com and complete the onboarding process.
If you already have a bexio account, you can skip this step.
- Go to the developer portal at https://developer.bexio.com and log in using your bexio credentials.
- Read and accept the terms and conditions (please pay special attention to the commercial use regulations mentioned in Section 4.4).
- Create a new app and make sure that you define a valid site for the "Allowed redirect URL" field(s)
- By clicking on the section "App Details" you can reveal the Client ID and Client Secret
- Initiate the Authorization Code Flow to obtain an access token.
- Use the access token to create a request to the bexio API. The example below fetches a list of contacts (make sure to request the scope `contact_show` in the authorization code flow)
``curl -X GET \
https://api.bexio.com/2.0/contact \
-H 'Accept: application/json' \
-H 'Authorization: Bearer {access-token}'
``
Make sure to replace `{access-token}` with the token you received in Step 6.
