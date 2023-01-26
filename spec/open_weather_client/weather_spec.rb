RSpec.describe OpenWeatherClient::Weather do
  describe 'current weather' do
    before :each do
      OpenWeatherClient.configuration.appid = '1234567890'
      stub_request(:get, 'https://api.openweathermap.org/data/2.5/weather').with(query: hash_including(:appid, :lat, :lon, :lang, :units)).to_return(body: File.open('./spec/fixtures/weather/current.json'))
    end

    let(:lat) { 50.3569 }
    let(:lon) { 7.5890 }

    subject { OpenWeatherClient::Weather.current(lat: lat, lon: lon) }

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
        context 'latitude' do
          let(:lat) { 100 }

          it 'raises ange error' do
            expect { subject }.to raise_error RangeError
          end
        end

        context 'longitude' do
          let(:lon) { 200 }

          it 'raises ange error' do
            expect { subject }.to raise_error RangeError
          end
        end
      end
    end
  end
end
