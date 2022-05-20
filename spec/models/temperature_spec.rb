require 'rails_helper'

RSpec.describe Temperature do
  let(:temp) { described_class.new('Gibsonia', 'PA') }
  let(:coordinates) { [40.6300671, -79.9695004] }
  let(:geo_result) { instance_double('Geocoder::Result::Nominatim', coordinates:) }

  describe '.forecast_cache' do
    let(:memory_store) { ActiveSupport::Cache.lookup_store(:memory_store) }
    let(:cache) { Rails.cache }

    before do
      allow(Rails).to receive(:cache).and_return(memory_store)
      Rails.cache.clear
    end

    after do
      Rails.cache.clear
    end

    it 'returns forecast from cache' do
      cache_key = Digest::SHA1.hexdigest 'GibsoniaPA'
      Rails.cache.write(cache_key, 'cold and rainy')

      expect(temp.forecast_cache).to eq({ cache_hit: true, forecast: 'cold and rainy' })
    end

    it 'calls forecast when not in cache' do
      allow(temp).to receive(:forecast).and_return('partly cloudy')

      expect(temp.forecast_cache).to eq({ cache_hit: false, forecast: 'partly cloudy' })
    end
  end

  describe '.forecast' do
    it 'returns the forecast' do
      grid_endpoint = instance_double(
        'Faraday::Response',
        status: 200,
        body: "{\"properties\":{\"forecast\":\"https://www.example.com/points\"}}"
      )
      grid_forecast = instance_double(
        'Faraday::Response',
        status: 200,
        body: "{\"properties\":{\"periods\":\"warm and sunny\"}}"
      )
      allow(Geocoder).to receive(:search).and_return([geo_result])
      allow(Faraday).to receive(:get).with('https://api.weather.gov/points/40.6301,-79.9695').and_return(grid_endpoint)
      allow(Faraday).to receive(:get).with('https://www.example.com/points').and_return(grid_forecast)

      expect(temp.forecast).to eq 'warm and sunny'
    end

    it 'returns empty array when the coordinates cannot be determined' do
      allow(Geocoder).to receive(:search).and_return([])

      expect(temp.forecast).to eq []
    end

    it 'returns empty array when there is no grid coordinate' do
      grid_endpoint = instance_double(
        'Faraday::Response',
        status: 200,
        body: "{}"
      )
      allow(Geocoder).to receive(:search).and_return([geo_result])
      allow(Faraday).to receive(:get).with('https://api.weather.gov/points/40.6301,-79.9695').and_return(grid_endpoint)

      expect(temp.forecast).to eq []
    end

    it 'catches errors' do
      allow(Geocoder).to receive(:search).and_raise(StandardError)

      expect(temp.forecast).to eq []
    end
  end

  describe '.coordinates' do
    it 'returns latitude and longitude' do
      allow(Geocoder).to receive(:search).and_return([geo_result])

      expect(temp.coordinates).to eq coordinates
    end

    it 'returns empty array if there are no results' do
      allow(Geocoder).to receive(:search).and_return([])

      expect(temp.coordinates).to eq []
    end
  end

  describe '.points_url' do
    it 'assembles the url to determine the forcast url' do
      expect(temp.points_url(40.6300671, -79.9695004)).to eq 'https://api.weather.gov/points/40.6301,-79.9695'
    end
  end

  describe '.grid_endpoint' do
    it 'returns empty string if the response is not a 200' do
      response = instance_double('Faraday::Response', status: 400)
      allow(Faraday).to receive(:get).and_return(response)

      expect(temp.grid_endpoint('https://www.example.com/')).to eq ''
    end

    it 'returns the forecast url' do
      response = instance_double(
        'Faraday::Response',
        status: 200,
        body: "{\"properties\":{\"forecast\":\"https://www.example.com/points\"}}"
      )
      allow(Faraday).to receive(:get).and_return(response)

      expect(temp.grid_endpoint('https://www.example.com/')).to eq 'https://www.example.com/points'
    end
  end

  describe '.grid_forecast' do
    it 'returns empty string if the response is not a 200' do
      response = instance_double('Faraday::Response', status: 400)
      allow(Faraday).to receive(:get).and_return(response)

      expect(temp.grid_forecast('https://www.example.com/')).to eq ''
    end

    it 'returns the forecast url' do
      response = instance_double(
        'Faraday::Response',
        status: 200,
        body: "{\"properties\":{\"periods\":\"warm and sunny\"}}"
      )
      allow(Faraday).to receive(:get).and_return(response)

      expect(temp.grid_forecast('https://www.example.com/')).to eq 'warm and sunny'
    end
  end
end
