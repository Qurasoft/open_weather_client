# frozen_string_literal: true

class RailsTest
  class Credentials
    def self.open_weather_client!; end
  end

  class Application
    def self.credentials
      RailsTest::Credentials
    end
  end

  def self.application
    RailsTest::Application
  end
end

RSpec.describe OpenWeatherClient::Configuration do
  before :each do
    OpenWeatherClient.reset
  end

  subject { OpenWeatherClient.configuration }

  it 'has a default configuration' do
    is_expected.to have_attributes(appid: nil)
    is_expected.to have_attributes(caching: :none)
    is_expected.to have_attributes(units: 'metric')
    is_expected.to have_attributes(url: 'https://api.openweathermap.org/data')
    is_expected.to have_attributes(user_agent: "Open Weather Client/#{OpenWeatherClient::VERSION}")
  end

  context 'rails credentials' do
    it 'raises an error if Rails is not available' do
      expect { subject.load_from_rails_credentials }.to raise_error RuntimeError
    end

    context 'available' do
      it 'loads appid from credentials' do
        stub_const 'Rails', RailsTest
        allow(Rails.application.credentials).to receive(:'open_weather_client!').and_return({
                                                                                              appid: '1234567890'
                                                                                            })
        subject.load_from_rails_credentials
        expect(subject.appid).to eq '1234567890'
      end
    end
  end
end
