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

  describe '#cache_key' do
    it 'formats lat, lon and time' do
      expect(subject.cache_key(0.5, 1.0, Time.new(2023, 2, 1, 9, 43))).to eq 'weather:0.5:1.0:2023-02-01T09'
    end
  end
end
