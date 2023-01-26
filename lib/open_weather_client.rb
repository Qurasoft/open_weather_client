require 'open_weather_client/configuration'
require 'open_weather_client/version'
require 'open_weather_client/weather'

module OpenWeatherClient
  class AuthenticationError < StandardError; end

  class << self
    attr_accessor :configuration, :testing
  end

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.reset
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
