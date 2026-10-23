# Personal Access Tokens (PAT)

Personal Access Tokens (PAT) can be managed on https://developer.bexio.com/pat and are convenient way to issue API access tokens for personal use:
- A PAT has all default scopes granted and therefore has full access to your company's data.
- A PAT is valid for 60 days after creation.
- A PAT can be revoked by deleting it on developer.bexio.com. After deletion, a PAT can no longer be used to access the API. In the worst case, it might take up to 1 hour until the revocation takes full effect. Subsystems might still be accessible by the token during this period.
If you have other requirements, like restricting the scope granted to a token, please use the Authorization Code Flow instead.
To use a PAT to authorise a request, it can be used as a bearer token in the `Authorization` header of a request:
``Authorization: Bearer eyJraWQiOiI2ZGM2YmJlOC1iMjZjLTExZTgtOGUwZC0w...
``
PAT are strictly intended for personal use and should never be shared with anyone else. If you have a use case that requires the sharing of access tokens with another party, you must use the Authorization Code Flow instead.
