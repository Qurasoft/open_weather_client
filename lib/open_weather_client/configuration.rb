# frozen_string_literal: true

module OpenWeatherClient
  ##
  # Configuratin of OpenWeatherClient
  class Configuration
    # [String] Used api version. One of :v25, :v30. Default :v25
    attr_accessor :api_version
    # [String] API key to access OpenWeatherMap
    attr_accessor :appid
    # Caching method. One of :none, :memory
    attr_reader :caching
    # [String] Requested language of the result
    attr_accessor :lang
    # [Integer] Maximum allowed number of entries when using caching method :memory
    attr_accessor :max_memory_entries
    # [Proc] Quantization of latitude and longitude
    attr_accessor :spatial_quantization
    # [String] Requested units of the result
    attr_accessor :units
    # [String] Base URL of the requests to OpenWeatherMap
    attr_accessor :url
    # [String] User-Agent of the requests made to OpenWeatherMap
    attr_accessor :user_agent

    ##
    # Initialize a new Configuration with the default settings
    def initialize
      @api_version = :v25
      @caching = OpenWeatherClient::Caching.new
      @lang = 'de'
      @max_memory_entries = 10_000
      @units = 'metric'
      @url = 'https://api.openweathermap.org/data'
      @user_agent = "Open Weather Client/#{OpenWeatherClient::VERSION}"
    end

    ##
    # Set the caching method
    #
    # @param cache_class[Class] class definition adhering to the OpenWeatherClient::Caching interface
    def caching=(cache_class)
      @caching = cache_class.new
    end

    ##
    # Load appid from Rails credentials
    #
    # Load the appid from Rails credentials using the top-level key 'open_weather_client'
    #
    # @raise [RuntimeError] if not using Rails
    def load_from_rails_credentials
      raise 'This method is only available in Ruby on Rails.' unless defined? Rails

      settings = Rails.application.credentials.open_weather_client!
      self.appid = settings[:appid]
    end
  end
end
