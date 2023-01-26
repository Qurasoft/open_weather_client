# frozen_string_literal: true

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'open_weather_client/version'

Gem::Specification.new do |spec|
  spec.name          = 'open_weather_client'
  spec.version       = OpenWeatherClient::VERSION
  spec.required_ruby_version = '>= 3.0'
  spec.required_rubygems_version = '>= 2'
  spec.authors       = ['Lucas Keune']
  spec.email         = ['lucas.keune@qurasoft.de']

  spec.summary       = 'Access weather data from OpenWeatherMap'
  spec.description   = ''
  spec.homepage      = 'https://github.com/Qurasoft/open_weather_client'
  spec.license       = 'MIT'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/Qurasoft/open_weather_client'
  spec.metadata['changelog_uri'] = 'https://github.com/Qurasoft/open_weather_client/blob/main/CHANGES.md'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = 'bin'
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'faraday', '>= 2'

  spec.add_development_dependency 'bundler', '>= 1.17'
  spec.add_development_dependency 'rake', '>= 10.0'
  spec.add_development_dependency 'rspec', '>= 3.0'
  spec.add_development_dependency 'rubocop'
  spec.add_development_dependency 'simplecov'
  spec.add_development_dependency 'webmock'
end
