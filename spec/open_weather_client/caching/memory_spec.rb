# frozen_string_literal: true

require 'open_weather_client/caching/memory'

RSpec.describe OpenWeatherClient::Caching::Memory do
  let(:lat) { 50.3569 }
  let(:lon) { 7.5890 }
  let(:time) { Time.now }
  let(:data) { { stored_data: :data } }

  before :each do
    OpenWeatherClient.configuration.caching = OpenWeatherClient::Caching::Memory
  end

  context 'get' do
    it 'raises key error' do
      expect { subject.get(lat: lat, lon: lon, time: time) }.to raise_error KeyError
    end

    context 'retrieve data' do
      before :each do
        subject.store(lat: lat, lon: lon, time: time, data: data)
      end

      it 'returns stored data' do
        expect(subject.get(lat: lat, lon: lon, time: time)).to eq data
      end
    end
  end

  context 'store' do
    let(:data) { { stored_data: :data } }

    it 'returns input data' do
      expect(subject.store(lat: lat, lon: lon, time: time, data: data)).to eq data
    end

    context 'eviction' do
      before :each do
        OpenWeatherClient.configuration.max_memory_entries = 2

        subject.store(lat: lat1, lon: lon, time: time, data: data)
        subject.store(lat: lat2, lon: lon, time: time, data: data)
        subject.get(lat: lat1, lon: lon, time: time)
        subject.store(lat: lat3, lon: lon, time: time, data: data)
      end

      let(:lat1) { 50.0 }
      let(:lat2) { 51.1 }
      let(:lat3) { 52.2 }

      it 'evicts oldest used data' do
        expect(subject.get(lat: lat1, lon: lon, time: time)).to eq data
        expect { subject.get(lat: lat2, lon: lon, time: time) }.to raise_error KeyError
        expect(subject.get(lat: lat3, lon: lon, time: time)).to eq data
      end
    end
  end
end
