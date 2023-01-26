module OpenWeatherClient
  class Cache
    attr :memory_cache, :memory_keys

    def initialize
      @memory_cache = {}
      @memory_keys = []
    end

    def get(lat:, lon:, time:)
      key = cache_key(lat: lat, lon: lon, time: time)
      raise KeyError unless present?(key)

      caching = OpenWeatherClient.configuration.caching

      if caching == :memory
        @memory_keys.delete(key)
        @memory_keys << key
        return @memory_cache[key]
      end

      nil
    end

    def store(lat:, lon:, data:, time:)
      caching = OpenWeatherClient.configuration.caching
      key = cache_key(lat: lat, lon: lon, time: time)

      if caching == :memory
        @memory_cache[key] = data
        @memory_keys.delete(key)
        @memory_keys << key

        if @memory_keys.count > OpenWeatherClient.configuration.max_memory_entries
          @memory_cache.delete(@memory_keys.shift)
        end
      end

      data
    end

    private

    def cache_key(lat:, lon:, time:)
      "#{lat}_#{lon}_#{time.strftime('%Y-%m-%dT%H')}"
    end

    def present?(key)
      caching = OpenWeatherClient.configuration.caching
      return false if caching == :none

      return @memory_keys.include?(key) if caching == :memory

      false
    end
  end
end
