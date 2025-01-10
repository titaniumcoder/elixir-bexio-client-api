# Changelog

## 0.6.3

* All empty bodies as JSON removed due to bug leading to error 415

## 0.6.2

* Placeholder version due to issue with build.

## 0.6.1

* Reduced retries down from 100 to 3 (so rate limit can be handled, but not general network problems)

## 0.6.0

* Version updates of dependencies, minor update for this

## 0.5.3

* Add optional configuration to IDP_URL to enable mocking the bexio api completely with a customized mock.

## 0.5.2

* Just added a test for the access key refresher logic

## 0.5.1

* Fix forgotten Access Keys by using ETS temporary storage

## 0.5.0

* SearchCriteria changed to sigil ~f with separations for reduced name lengths (old functionality is still there for now)
* Payment Types added

## 0.4.2

* Added Github Action to automatically publish a package version

## 0.4.2

* Added Logic fot notes needed for the search

## 0.4.1

* Added Logic fot notes needed for the search

## 0.4.0

* Removing dependency to `tesla`
* Adding `req` as optional dependency
* Adding `req` setup for automatic access_token renewal and retry delay using bexio headers
