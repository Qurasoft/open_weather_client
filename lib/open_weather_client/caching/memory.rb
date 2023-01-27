module OpenWeatherClient
  class Caching
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

      ##
      # Read an entry out of the memory cache
      #
      # @param key[String] key into the cache. Is stored at the end of the key registry
      #
      # @return [Hash] the stored data
      def caching_get(key)
        @memory_keys.delete(key)
        @memory_keys << key if @memory_cache.key? key
        @memory_cache[key]
      end

      ##
      # Store an entry in the memory cache
      #
      # Evicts the entry with the least recent access if the memory cache is full
      #
      # @param key[String] key into the cache. Is stored at the end of the key registry
      # @param data[Hash] data to be stored, must be able to be formatted and parsed as text
      #
      # @return [Hash] the input data
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
