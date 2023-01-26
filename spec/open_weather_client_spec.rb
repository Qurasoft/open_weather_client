RSpec.describe OpenWeatherClient do
  it 'has a version number' do
    expect(OpenWeatherClient::VERSION).not_to be nil
  end

  context 'cache' do
    subject { OpenWeatherClient.cache }

    it 'is a singleton' do
      is_expected.to be_a OpenWeatherClient::Cache
      is_expected.to be OpenWeatherClient.cache
    end

    it 'can be reset' do
      old_cache = OpenWeatherClient.cache
      OpenWeatherClient.reset
      new_cache = OpenWeatherClient.cache

      expect(old_cache).to be_a OpenWeatherClient::Cache
      expect(new_cache).to be_a OpenWeatherClient::Cache
      expect(old_cache).not_to be new_cache
    end
  end

  context 'configuration' do
    subject { OpenWeatherClient.configuration }

    it 'is a singleton' do
      is_expected.to be_a OpenWeatherClient::Configuration
      is_expected.to be OpenWeatherClient.configuration
    end

    it 'can be reset' do
      old_configuration = OpenWeatherClient.configuration
      OpenWeatherClient.reset
      new_configuration = OpenWeatherClient.configuration

      expect(old_configuration).to be_a OpenWeatherClient::Configuration
      expect(new_configuration).to be_a OpenWeatherClient::Configuration
      expect(old_configuration).not_to be new_configuration
    end
  end

  context '#configure' do
    it 'yields the configuration' do
      expect { |b| OpenWeatherClient.configure(&b) }.to yield_with_args OpenWeatherClient.configuration
    end
  end

  context 'project_root' do
    it 'is working directory' do
      hide_const('Rails')
      hide_const('Bundler')

      expect(OpenWeatherClient.project_root).to eq(Dir.pwd)
    end

    it 'is bundler root if running in bundler' do
      test_bundler = Class.new do
        def self.root
          'BUNDLER_ROOT_PATH'
        end
      end
      stub_const('Bundler', test_bundler)
      hide_const('Rails')

      expect(OpenWeatherClient.project_root).to eq('BUNDLER_ROOT_PATH')
    end

    it 'is rails root if running in rails' do
      test_rails = Class.new do
        def self.root
          'RAILS_ROOT_PATH'
        end
      end
      stub_const('Rails', test_rails)
      hide_const('Bundler')

      expect(OpenWeatherClient.project_root).to eq('RAILS_ROOT_PATH')
    end
  end
end
