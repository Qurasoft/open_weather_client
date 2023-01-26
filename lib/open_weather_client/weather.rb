require 'faraday'

module OpenWeatherClient
  class Weather
    def self.current(lat:, lon:)
      connection = Faraday.new(
        url: OpenWeatherClient.configuration.url,
        params: {
          appid: OpenWeatherClient.configuration.appid,
          lat: lat,
          lon: lon,
          lang: OpenWeatherClient.configuration.lang,
          units: OpenWeatherClient.configuration.units
        },
        headers: {
          'User-Agent': OpenWeatherClient.configuration.user_agent
        }
      ) do |f|
        f.response :raise_error
        f.response :json
      end

      begin
        response = connection.get('2.5/weather')
        response.body
      rescue Faraday::UnauthorizedError
        raise OpenWeatherClient::AuthenticationError
      end
    end
  end
end
