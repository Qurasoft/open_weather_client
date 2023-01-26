# frozen_string_literal: true

module OpenWeatherClient
  ##
  # Caching of OpenWeatherMap requests
  #
  # The entries are cached according to latitude, longitude and time of the request.
  # The time is clamped to the current hour
  class Cache
    # Memory cache to store a hash of keys and request data
    attr :memory_cache
    # Key registry of the memory cache. The first entry is the key of the least recently accessed data
    attr :memory_keys

    ##
    # Initialize an empty cache
    def initialize
      @memory_cache = {}
      @memory_keys = []
    end

    ##
    # Get an entry out of the cache defined by its +lat+, +lon+ and +time+.
    #
    # @param lat[Float] latitude of the requests location
    # @param lon[Float] longitude of the requests location
    # @param time[Time] time of the request
    #
    # @raise [KeyError] if no entry is present
    # @raise [NotImplementedError] if an unsupported caching method is used
    #
    # @return [Hash] the stored data
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

    ##
    # Store the data by its +lat+, +lon+ and +time+.
    #
    # @param data[Hash] data to be stored, must be able to be formatted and parsed as text
    # @param lat[Float] latitude of the requests location
    # @param lon[Float] longitude of the requests location
    # @param time[Time] time of the request
    #
    # @return [Hash] the input data
    def store(data:, lat:, lon:, time:)
      key = cache_key(lat, lon, time)

      case OpenWeatherClient.configuration.caching
      when :memory
        memory_store(key, data)
      else
        data
      end
    end

    private

    ##
    # Calculate the key for storage in the cache
    #
    # @param lat[Float] latitude of the requests location
    # @param lon[Float] longitude of the requests location
    # @param time[Time] time of the request
    def cache_key(lat, lon, time)
      "#{lat}_#{lon}_#{time.strftime('%Y-%m-%dT%H')}"
    end

    ##
    # Read an entry out of the memory cache
    #
    # @param key[String] key into the cache. Is stored at the end of the key registry
    #
    # @return [Hash] the stored data
    def memory_get(key)
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
    def memory_store(key, data)
      @memory_cache[key] = data
      @memory_keys.delete(key)
      @memory_keys << key

      if @memory_keys.count > OpenWeatherClient.configuration.max_memory_entries
        @memory_cache.delete(@memory_keys.shift)
      end

      data
    end

    ##
    # Check whether a key is present in the cache
    #
    # @return always false when the cache method is not supported or caching is not enabled
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
