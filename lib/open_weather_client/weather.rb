module OpenWeatherClient
  class Weather
    attr_accessor :lat, :lon, :time

    def initialize(lat:, lon:, time: Time.now)
      raise RangeError unless (-90..90).member?(lat)
      raise RangeError unless (-180..180).member?(lon)

      @lat = lat
      @lon = lon
      @time = time
    end

    def get
      OpenWeatherClient.cache.get(lat: lat, lon: lon, time: time)
    rescue KeyError
      OpenWeatherClient::Request.get(lat: lat, lon: lon)
    end
  end
end
