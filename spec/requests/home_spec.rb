require 'rails_helper'

RSpec.describe 'Homes', type: :request do
  describe 'GET "/"' do
    it 'returns http success' do
      get '/'
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET "/forecast"' do
    it 'returns 422 if it is missing city' do
      get '/forecast', params: { state: 'PA' }

      expect(response.status).to eq 422
      expect(response.body).to eq 'unprocessable_entity'
    end

    it 'returns 422 if it is missing city' do
      get '/forecast', params: { city: 'Gibsonia' }

      expect(response.status).to eq 422
      expect(response.body).to eq 'unprocessable_entity'
    end

    it 'returns forecast JSON' do
      forecast = { cache_hit: true, forecast: 'warm and sunny' }
      temperature = instance_double('Temperature', forecast_cache: forecast)
      allow(Temperature).to receive(:new).and_return(temperature)

      get '/forecast', params: { city: 'Gibsonia', state: 'PA' }
      expect(response.status).to eq 200
      expect(response.body).to eq forecast.to_json
    end
  end
end
