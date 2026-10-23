# Rate Limiting

The bexio API enforces a rate limit that limits the number of requests a company can make per minute.
If this limit is reached, the API will return a 429 status code to the client.
HTTP Headers
The table below describes the relevant headers regarding the API rate-limit.
Header
Description
RateLimit-Limit
The current limit for this time period.
RateLimit-Remaining
The remaining amount of requests allowed for this time period.
RateLimit-Reset
The remaining time until the next time period starts (seconds).
