require 'open_weather_client/cache'
require 'open_weather_client/configuration'
require 'open_weather_client/request'
require 'open_weather_client/version'
require 'open_weather_client/weather'

module OpenWeatherClient
  class AuthenticationError < StandardError; end
  class NotCurrentError < StandardError; end

  class << self
    attr_writer :cache, :configuration
  end

  def self.cache
    @cache ||= Cache.new
  end

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.reset
    @cache = Cache.new
    @configuration = Configuration.new
  end

  def self.configure
    yield configuration
  end

  def self.project_root
    return Rails.root if defined?(Rails)
    return Bundler.root if defined?(Bundler)

    Dir.pwd
  end

  def self.gem_root
    spec = Gem::Specification.find_by_name('open_weather_client')
    spec.gem_dir rescue project_root
  end
end
