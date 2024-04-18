# frozen_string_literal: true

require 'faraday'

module OpenWeatherClient
  ##
  # Request the weather from OpenWeatherMap
  class Request
    ##
    # Request the current weather
    #
    # @param lat[Float] latitude of the requests location
    # @param lon[Float] longitude of the requests location
    # @param time[Time] time of the request
    #
    # @raise [APIVersionNotSupportedError] if the configured api version is not supported
    # @raise [AuthenticationError] if the request is not authorized, e.g in case the API key is not correct
    # @raise [NotCurrentError] if the requested time is older than 1 hour
    #
    # @return the response body
    def self.get(lat:, lon:, time: Time.now)
      raise OpenWeatherClient::NotCurrentError if time < Time.now - 1 * 60 * 60

      begin
        response = connection(lat, lon).get(path)
        OpenWeatherClient.cache.store(lat: lat, lon: lon, data: response.body, time: time)
      rescue Faraday::UnauthorizedError
        raise OpenWeatherClient::AuthenticationError
      end
    end

    def self.connection(lat, lon)
      Faraday.new(
        url: OpenWeatherClient.configuration.url,
        params: params(lat, lon),
        headers: headers
      ) do |f|
        f.response :raise_error
        f.response :json
      end
    end

    def self.headers
      {
        'User-Agent': OpenWeatherClient.configuration.user_agent
      }
    end

    def self.params(lat, lon)
      {
        appid: OpenWeatherClient.configuration.appid,
        lat: lat,
        lon: lon,
        lang: OpenWeatherClient.configuration.lang,
        units: OpenWeatherClient.configuration.units
      }
    end

    def self.path
      case OpenWeatherClient.configuration.api_version
      when :v25
        '2.5/weather'
      when :v30
        '3.0/onecall'
      else
        raise OpenWeatherClient::APIVersionNotSupportedError
      end
    end
  end
end
