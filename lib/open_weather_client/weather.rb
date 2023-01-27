# frozen_string_literal: true

module OpenWeatherClient
  ##
  # Request weather information from OpenWeatherMap or the cache
  class Weather
    # [Float] latitude of the requested location
    attr_accessor :lat
    # [Float] longitude of the requested location
    attr_accessor :lon
    # [Time] time of the requested weather
    attr_accessor :time

    ##
    # Initialize a new Weather request
    #
    # @param lat[Float] latitude of the requests location
    # @param lon[Float] longitude of the requests location
    # @param time[Time] time of the request
    #
    # @raise [RangeError] if one +lat+ or +lon+ are out of the expected ranges
    def initialize(lat:, lon:, time: Time.now)
      if OpenWeatherClient.configuration.spatial_quantization.respond_to?(:call)
        lat, lon = OpenWeatherClient.configuration.spatial_quantization.call(lat, lon)
      end

      raise RangeError unless (-90..90).member?(lat)
      raise RangeError unless (-180..180).member?(lon)

      @lat = lat
      @lon = lon
      @time = time
    end

    ##
    # get the weather according to the specified parameters
    #
    # @raise [AuthenticationError] if the request is not authorized, e.g in case the API key is not correct
    #
    # @return the stored or received data
    def get
      OpenWeatherClient.cache.get(lat: lat, lon: lon, time: time)
    rescue KeyError
      OpenWeatherClient::Request.get(lat: lat, lon: lon)
    end
  end
end
