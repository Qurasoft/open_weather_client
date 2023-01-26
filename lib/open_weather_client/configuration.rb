module OpenWeatherClient
  class Configuration
    attr_accessor :appid, :lang, :units, :url, :user_agent

    def initialize
      @lang = 'de'
      @units = 'metric'
      @url = 'https://api.openweathermap.org/data'
      @user_agent = "Open Weather Client/#{OpenWeatherClient::VERSION}"
    end

    def load_from_rails_credentials
      unless defined? Rails
        raise RuntimeError, 'This method is only available in Ruby on Rails.'
      end

      settings = Rails.application.credentials.open_weather_client!
      self.appid = settings[:appid]
    end
  end
end
