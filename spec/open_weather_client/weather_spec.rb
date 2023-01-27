# frozen_string_literal: true

RSpec.describe OpenWeatherClient::Weather do
  describe 'current weather' do
    let(:lat) { 50.3569 }
    let(:lon) { 7.5890 }

    subject { OpenWeatherClient::Weather.new(lat: lat, lon: lon) }

    describe 'spatial quantization' do
      it 'does not change lat and lon' do
        expect(subject).to have_attributes(lat: lat)
        expect(subject).to have_attributes(lon: lon)
      end

      describe 'with spatial quantization' do
        before :each do
          @quantization = spy('quantization')
          allow(@quantization).to receive(:call).and_return([25, 50])

          OpenWeatherClient.configuration.spatial_quantization = @quantization
        end

        it 'calls quantization' do
          subject

          expect(@quantization).to have_received(:call).once.with(lat, lon)
        end

        it 'sets lat and lon' do
          is_expected.to have_attributes(lat: 25)
          is_expected.to have_attributes(lon: 50)
        end

        it 'tests range of quantization' do
          OpenWeatherClient.configuration.spatial_quantization = proc { |_lat, _lon| [-250, 360] }

          expect { subject }.to raise_error RangeError
        end
      end
    end

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
