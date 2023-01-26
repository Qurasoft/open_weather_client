module OpenWeatherClient
  class Configuration
    attr_accessor :appid, :caching, :lang, :max_memory_entries, :units, :url, :user_agent

    def initialize
      @caching = :none
      @lang = 'de'
      @max_memory_entries = 10_000
      @units = 'metric'
      @url = 'https://api.openweathermap.org/data'
      @user_agent = "Open Weather Client/#{OpenWeatherClient::VERSION}"
    end

    def load_from_rails_credentials
      raise 'This method is only available in Ruby on Rails.' unless defined? Rails

      settings = Rails.application.credentials.open_weather_client!
      self.appid = settings[:appid]
    end
  end
end
