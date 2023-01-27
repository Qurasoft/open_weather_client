# frozen_string_literal: true

RSpec.describe OpenWeatherClient::Caching do
  let(:lat) { 50.3569 }
  let(:lon) { 7.5890 }
  let(:time) { Time.now }
  let(:data) { { stored_data: :data } }

  describe 'no caching' do
    context 'get' do
      it 'raises key error' do
        expect { subject.get(lat: lat, lon: lon, time: time) }.to raise_error KeyError
      end
    end

    context 'store' do
      it 'returns input data' do
        expect(subject.store(lat: lat, lon: lon, time: time, data: data)).to eq data
      end
    end
  end
end
