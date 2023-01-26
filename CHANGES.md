# Open Weather Client Changelog

## 0.1.1
- Raise `OpenWeatherClient::AuthenticationError` if the request is not authorized
- - Raise `RangeError` if latitude or longitude is out of the allowed range
- Raise `Faraday::Error` if the request fails otherwise 

## 0.1.0
- Initial commit of the Open Weather Client gem
- Configuration of OpenWeatherClient
- Request current weather with `OpenWeatherClient.current(lat:, lon:)`
