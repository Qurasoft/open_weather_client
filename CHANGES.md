# Open Weather Client Changelog

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
