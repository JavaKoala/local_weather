require 'rails_helper'

RSpec.describe Temperature do
  describe '.coordinates' do
    let(:temp) { described_class.new('Gibsonia', 'PA') }

    it 'returns latitude and longitude' do
      coordinates = [40.6300671, -79.9695004]
      geo_result = instance_double('Geocoder::Result::Nominatim', coordinates: coordinates)
      allow(Geocoder).to receive(:search).and_return([geo_result])

      expect(temp.coordinates).to eq coordinates
    end

    it 'returns empty array if there are no results' do
      allow(Geocoder).to receive(:search).and_return([])

      expect(temp.coordinates).to eq []
    end
  end
end