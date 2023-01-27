module OpenWeatherClient
  class Caching
    ##
    # Memory cache of OpenWeatherMap requests
    #
    # The requests are cached in memory up to the number specified in config.max_memory_entries.
    # When the limit is reached the least recently used entry is evicted.
    class Memory < OpenWeatherClient::Caching
      # Memory cache to store a hash of keys and request data
      attr :memory_cache
      # Key registry of the memory cache. The first entry is the key of the least recently accessed data
      attr :memory_keys

      ##
      # Initialize an empty cache
      def initialize
        super
        @memory_cache = {}
        @memory_keys = []
      end

      private

      def caching_get(key)
        @memory_keys.delete(key)
        @memory_keys << key if @memory_cache.key? key
        @memory_cache[key]
      end

      def caching_store(key, data)
        @memory_cache[key] = data
        @memory_keys.delete(key)
        @memory_keys << key

        if @memory_keys.count > OpenWeatherClient.configuration.max_memory_entries
          @memory_cache.delete(@memory_keys.shift)
        end

        data
      end

      def present?(key)
        @memory_keys.include?(key)
      end
    end
  end
end
