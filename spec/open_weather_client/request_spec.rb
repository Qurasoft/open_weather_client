# frozen_string_literal: true

RSpec.describe OpenWeatherClient::Request do
  describe 'current weather' do
    before :each do
      OpenWeatherClient.configuration.appid = '1234567890'
      stub_request(:get, 'https://api.openweathermap.org/data/2.5/weather').with(query: hash_including(:appid, :lat, :lon, :lang, :units)).to_return(body: File.open('./spec/fixtures/weather/current.json'))
    end

    let(:lat) { 50.3569 }
    let(:lon) { 7.5890 }

    subject { OpenWeatherClient::Request.get(lat: lat, lon: lon) }

    it 'requests the current weather' do
      subject

      expect(WebMock).to have_requested(:get, 'https://api.openweathermap.org/data/2.5/weather').with query: { appid: OpenWeatherClient.configuration.appid, lat: lat, lon: lon, lang: OpenWeatherClient.configuration.lang, units: OpenWeatherClient.configuration.units }
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
        OpenWeatherClient.configuration.caching = :memory
      end

      it 'uses cached response' do
        subject
        subject

        expect(WebMock).to have_requested(:get, 'https://api.openweathermap.org/data/2.5/weather').once.with query: hash_including
      end
    end
  end
end
