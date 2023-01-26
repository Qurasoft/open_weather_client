# Open Weather Client

[![Gem Version](https://badge.fury.io/rb/open_weather_client.svg)](https://badge.fury.io/rb/open_weather_client)
![RSpec](https://github.com/qurasoft/open_weather_client/actions/workflows/ruby.yml/badge.svg)

Welcome to Open Weather Client. This gem allows you to easily send messages from your ruby project to Microsoft Teams channels.
It integrates in your rails project, when you are using bundler or even in plain ruby projects.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'open_weather_client'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install open_weather_client

## Usage
During configuration the OpenWeatherMap API key must be set. Afterwards it is as simple as calling `OpenWeatherClient.current(lat:, lon:)` to get the current weather at a location.

```ruby
# OpenWeatherClient initializer
OpenWeatherClient.configure do |config|
  config.appid = "1234567890"
end

# Receive the current weather in Koblenz
OpenWeatherClient::Weather.current(lat: 50.3569, lon: 7.5890)
```

### Secure Configuration
In Rails provides the credentials functionality for [environmental security](https://edgeguides.rubyonrails.org/security.html#environmental-security). This mechanism can be used by OpenWeatherClient to load the API key from an encrypted file. This also allows easy separation of production and development channel configuration.
All settings are defined under the top-level entry `open_weather_client`.
```yaml
# $ bin/rails credentials:edit
open_weather_client:
  appid: "<INSERT OPENWEATHERMAP API KEY HERE>"
```

After configuration of the credentials you can load the settings in your initializer with `#load_from_rails_configuration`.

```ruby
# OpenWeatherClient initializer
OpenWeatherClient.configure do |config|
  config.load_from_rails_credentials
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

You can define the channels you use for testing in the file `bin/channels.yml` or directly in the `bin/console` script.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/qurasoft/open_weather_client. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
