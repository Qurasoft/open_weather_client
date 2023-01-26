module OpenWeatherClient
  class Cache
    attr :memory_cache

    def initialize
      @memory_cache = {}
    end

    def get(lat:, lon:, time:)
      key = cache_key(lat: lat, lon: lon, time: time)
      raise KeyError unless present?(lat: lat, lon: lon)

      caching = OpenWeatherClient.configuration.caching

      return @memory_cache[key] if caching == :memory

      nil
    end

    def store(lat:, lon:, data:, time:)
      caching = OpenWeatherClient.configuration.caching
      key = cache_key(lat: lat, lon: lon, time: time)

      @memory_cache[key] = data if caching == :memory

      data
    end

    private

    def cache_key(lat:, lon:, time:)
      "#{lat}_#{lon}_#{time.strftime('%Y-%m-%dT%H')}"
    end

    def present?(key)
      caching = OpenWeatherClient.configuration.caching
      return false if caching == :none

      return @memory_cache.key?(key) if caching == :memory

      false
    end
  end
end
