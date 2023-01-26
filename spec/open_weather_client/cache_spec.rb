# frozen_string_literal: true

RSpec.describe OpenWeatherClient::Cache do
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

  describe 'memory caching' do
    before :each do
      OpenWeatherClient.configuration.caching = :memory
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

        let(:lat1) { 50 }
        let(:lat2) { 51 }
        let(:lat3) { 52 }

        it 'evicts oldest used data' do
          expect(subject.get(lat: lat1, lon: lon, time: time)).to eq data
          expect { subject.get(lat: lat2, lon: lon, time: time) }.to raise_error KeyError
          expect(subject.get(lat: lat3, lon: lon, time: time)).to eq data
        end
      end
    end
  end
end
