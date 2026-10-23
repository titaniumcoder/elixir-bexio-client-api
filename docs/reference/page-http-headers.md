# HTTP Headers

HTTP headers let the client and the server pass additional information with an HTTP request or response.
An HTTP header consists of its case-insensitive name followed by a colon (:), then by its value.
Request Headers
The following headers must be used for every request:
- `Accept: application/json`
- `Authorization: Bearer `
Additionally, the header `Content-Length: ` must be specified for requests with a payload.
The `Accept-Language: xx` can be used to specify the language you would like to have some translated elements returned to you. The `xx` has to be replaced by the ISO 639-1 code of the language. This is for example useful to have the tax codes in the user’s language.
Response Headers
The API will always indicate the return type with a `Content-Type` header.
Normally the header value is set to `application/json`, but can vary (e.g. for PDF exports).
Response Codes
Actions and errors yield different HTTP response codes. Please have a look at the expected response codes in the following list:
Code
Description
200
Request OK
201
New resource created
304
The resource has not been changed
400
The request parameters are invalid
401
The bearer token or the provided api key is invalid
403
You do not possess the required rights to access this resource
404
The resource could not be found / is unknown
411
Length Required
415
The data could not be processed or the accept header is invalid
422
Could not save the entity
429
Too many requests
500
An unexpected condition was encountered
503
The server is not available (maintenance work)
