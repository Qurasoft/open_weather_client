# OpenWeatherClient Changelog

## [Unreleased]

## 0.2.0
- Upgrade to Open Weather One Call API 3.0 through configuration option (#8)

## 0.1.6
- Relax required Ruby Version

## 0.1.5
- Fix `OpenWeatherClient::Weather#request` ignoring the time when cache is not hit

## 0.1.4
- Add rubocop rake task
- Run Github actions for ruby 3.2
- Change cache key format to `weather:<lat>:<lon>:<time}>` for better compatibility with redis
- Make `OpenWeatherClient::Caching#cache_key` public

## 0.1.3
Re-release of 0.1.2 since this version was released from an incorrect branch.

## 0.1.2 [yanked]
- Enable Rubocop Linter
- Add caching of requests (#1)
- Add location quantization (#3)
- Reset gem before every example in spec (#2)

## 0.1.1
- Raise `OpenWeatherClient::AuthenticationError` if the request is not authorized
- Raise `RangeError` if latitude or longitude is out of the allowed range
- Raise `Faraday::Error` if the request fails otherwise 

## 0.1.0
- Initial commit of the Open Weather Client gem
- Configuration of OpenWeatherClient
- Request current weather with `OpenWeatherClient.current(lat:, lon:)`
