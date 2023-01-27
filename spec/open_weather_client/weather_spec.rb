# frozen_string_literal: true

RSpec.describe OpenWeatherClient::Weather do
  describe 'current weather' do
    let(:lat) { 50.3569 }
    let(:lon) { 7.5890 }

    subject { OpenWeatherClient::Weather.new(lat: lat, lon: lon) }

    describe 'error handling' do
      context 'arguments' do
        context 'latitude' do
          let(:lat) { 100 }

          it 'raises range error' do
            expect { subject }.to raise_error RangeError
          end
        end

        context 'longitude' do
          let(:lon) { 200 }

          it 'raises range error' do
            expect { subject }.to raise_error RangeError
          end
        end
      end
    end
  end
end
