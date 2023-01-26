module OpenWeatherClient
  class Cache
    attr :memory_cache, :memory_keys

    def initialize
      @memory_cache = {}
      @memory_keys = []
    end

    def get(lat:, lon:, time:)
      key = cache_key(lat, lon, time)
      raise KeyError unless present?(key)

      case OpenWeatherClient.configuration.caching
      when :memory
        memory_get(key)
      else
        raise NotImplementedError
      end
    end

    def store(lat:, lon:, data:, time:)
      key = cache_key(lat, lon, time)

      case OpenWeatherClient.configuration.caching
      when :memory
        memory_store(key, data)
      else
        data
      end
    end

    private

    def cache_key(lat, lon, time)
      "#{lat}_#{lon}_#{time.strftime('%Y-%m-%dT%H')}"
    end

    def memory_get(key)
      @memory_keys.delete(key)
      @memory_keys << key
      @memory_cache[key]
    end

    def memory_store(key, data)
      @memory_cache[key] = data
      @memory_keys.delete(key)
      @memory_keys << key

      if @memory_keys.count > OpenWeatherClient.configuration.max_memory_entries
        @memory_cache.delete(@memory_keys.shift)
      end

      data
    end

    def present?(key)
      case OpenWeatherClient.configuration.caching
      when :none
        false
      when :memory
        @memory_keys.include?(key)
      else
        false
      end
    end
  end
end
