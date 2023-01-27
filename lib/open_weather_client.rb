# frozen_string_literal: true

require 'open_weather_client/caching'
require 'open_weather_client/configuration'
require 'open_weather_client/request'
require 'open_weather_client/version'
require 'open_weather_client/weather'

##
# Get weather data from OpenWeatherMap
module OpenWeatherClient
  # Error during authentication with the OpenWeatherMap servers
  class AuthenticationError < StandardError; end

  # The rquested time is not current enough for getting weather data from the OpenWeatherMap server
  class NotCurrentError < StandardError; end

  class << self
    # Caching singleton to access the cache
    attr_writer :cache
    # Configuration singleton to access the configuration
    attr_writer :configuration
  end

  ##
  # Get the singleton cache instance
  #
  # @return [Caching] the cache
  def self.cache
    @cache ||= Caching.new
  end

  ##
  # Get the singleton configuration instance
  #
  # @return [Configuration] the configuration
  def self.configuration
    @configuration ||= Configuration.new
  end

  ##
  # Reset cache and configuration
  def self.reset
    @cache = Caching.new
    @configuration = Configuration.new
  end

  ##
  # Configure OpenWeatherClient
  def self.configure
    yield configuration
  end

  ##
  # Get the project root
  def self.project_root
    return Rails.root if defined?(Rails)
    return Bundler.root if defined?(Bundler)

    Dir.pwd
  end

  ##
  # Get the gem root
  def self.gem_root
    spec = Gem::Specification.find_by_name('open_weather_client')
    spec.gem_dir
  rescue NoMethodError
    project_root
  end
end
