require 'faraday'

module OpenWeatherClient
  class Request
    def self.get(lat:, lon:, time: Time.now)
      raise OpenWeatherClient::NotCurrentError if time < Time.now - 1 * 60 * 60

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
        OpenWeatherClient.cache.store(lat: lat, lon: lon, data: response.body, time: time)
      rescue Faraday::UnauthorizedError
        raise OpenWeatherClient::AuthenticationError
      end
    end
  end
end
