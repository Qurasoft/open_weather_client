# frozen_string_literal: true

module OpenWeatherClient
  ##
  # Caching of OpenWeatherMap requests
  #
  # The entries are cached according to latitude, longitude and time of the request.
  # The time is clamped to the current hour
  #
  # This is the caching interface and equals a none cache. Get requests raise an error.
  class Caching
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

      caching_get(key)
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

      caching_store(key, data)

      data
    end

    ##
    # Calculate the key for storage in the cache
    #
    # @param lat[Float] latitude of the requests location
    # @param lon[Float] longitude of the requests location
    # @param time[Time] time of the request
    def cache_key(lat, lon, time)
      "weather:#{lat}:#{lon}:#{time.strftime('%Y-%m-%dT%H')}"
    end

    private

    ##
    # Read an entry out of the memory cache
    #
    # @param key[String] key into the cache. Is stored at the end of the key registry
    #
    # @return [Hash] the stored data
    def caching_get(key)
      raise NotImplementedError
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
      data
    end

    ##
    # Check whether a key is present in the cache
    #
    # @return always false when the cache method is not supported or caching is not enabled
    def present?(_key)
      false
    end
  end
end
