# Open Weather Client Changelog

## 0.1.1
- Raise `OpenWeatherClient::AuthenticationError` when request is not authorized
- Raise `Faraday::Error` when a request fails otherwise 

## 0.1.0
- Initial commit of the Open Weather Client gem
- Configuration of OpenWeatherClient
- Request current weather with `OpenWeatherClient.current(lat:, lon:)`
