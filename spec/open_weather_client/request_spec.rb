# frozen_string_literal: true

require 'open_weather_client/caching/memory'

RSpec.describe OpenWeatherClient::Request do
  let(:appid) { '1234567890' }
  let(:lat) { 50.3569 }
  let(:lon) { 7.5890 }

  subject { OpenWeatherClient::Request.get(lat: lat, lon: lon) }

  before :each do
    OpenWeatherClient.configuration.appid = appid
  end

  context 'when One Call API 3.0' do
    before :each do
      OpenWeatherClient.configuration.api_version = :v30
      stub_request(:get, 'https://api.openweathermap.org/data/3.0/onecall').with(query: hash_including(:appid, :lat, :lon, :lang, :units)).to_return(body: File.open('./spec/fixtures/weather/current.json'))
    end

    it 'requests the current weather from correct endpoint' do
      subject

      expect(WebMock).to have_requested(:get, 'https://api.openweathermap.org/data/3.0/onecall').with query: { appid: appid, lat: lat, lon: lon, lang: OpenWeatherClient.configuration.lang, units: OpenWeatherClient.configuration.units }
    end
  end

  context 'when unsupported API version' do
    before :each do
      OpenWeatherClient.configuration.api_version = :v666
    end

    it 'raises not supported error' do
      expect { subject }.to raise_error OpenWeatherClient::APIVersionNotSupportedError
    end
  end

  describe 'current weather with default configuration' do
    before :each do
      stub_request(:get, 'https://api.openweathermap.org/data/2.5/weather').with(query: hash_including(:appid, :lat, :lon, :lang, :units)).to_return(body: File.open('./spec/fixtures/weather/current.json'))
    end

    it 'requests the current weather' do
      subject

      expect(WebMock).to have_requested(:get, 'https://api.openweathermap.org/data/2.5/weather').with query: { appid: appid, lat: lat, lon: lon, lang: OpenWeatherClient.configuration.lang, units: OpenWeatherClient.configuration.units }
    end

    it 'has user agent' do
      subject

      expect(WebMock).to have_requested(:get, 'https://api.openweathermap.org/data/2.5/weather').with query: hash_including, headers: { "User-Agent": "Open Weather Client/#{OpenWeatherClient::VERSION}" }
    end

    describe 'error handling' do
      context 'authentication' do
        before :each do
          stub_request(:get, 'https://api.openweathermap.org/data/2.5/weather').with(query: hash_including(:appid, :lat, :lon, :lang, :units)).to_return(status: 401)
        end

        it 'raises authentication error' do
          expect { subject }.to raise_error OpenWeatherClient::AuthenticationError
        end
      end

      context 'arguments' do
        context 'time' do
          subject { OpenWeatherClient::Request.get(lat: lat, lon: lon, time: time) }

          let(:time) { Time.now - 2 * 60 * 60 }

          it 'raises not current error' do
            expect { subject }.to raise_error OpenWeatherClient::NotCurrentError
          end
        end
      end
    end

    describe 'caching' do
      before :each do
        OpenWeatherClient.configuration.caching = OpenWeatherClient::Caching::Memory
      end

      it 'uses cached response' do
        subject
        subject

        expect(WebMock).to have_requested(:get, 'https://api.openweathermap.org/data/2.5/weather').once.with query: hash_including
      end
    end
  end
end
