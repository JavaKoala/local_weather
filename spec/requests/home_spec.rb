require 'rails_helper'

RSpec.describe 'Homes', type: :request do
  describe 'GET "/"' do
    it 'returns http success' do
      get '/'
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET "/forecast"' do
    context 'when missing city' do
      before do
        get '/forecast', params: { state: 'PA' }
      end

      it { expect(response.status).to eq 422 }
      it { expect(response.body).to eq 'unprocessable_entity' }
    end

    context 'when missing state' do
      before do
        get '/forecast', params: { city: 'Gibsonia' }
      end

      it { expect(response.status).to eq 422 }
      it { expect(response.body).to eq 'unprocessable_entity' }
    end

    context 'when returning forecast json' do
      let(:forecast) { { cache_hit: true, forecast: 'warm and sunny' } }
      let(:temperature) { instance_double('Temperature', forecast_cache: forecast) }

      before do
        allow(Temperature).to receive(:new).and_return(temperature)
        get '/forecast', params: { city: 'Gibsonia', state: 'PA' }
      end

      it { expect(response.status).to eq 200 }
      it { expect(response.body).to eq forecast.to_json }
    end
  end
end
