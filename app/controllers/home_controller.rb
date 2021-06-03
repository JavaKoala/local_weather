class HomeController < ApplicationController
  def index
  end

  def forecast
    if address_params[:city].blank? || address_params[:state].blank?
      return render plain: 'unprocessable_entity', status: 422
    end

    temp = Temperature.new(address_params[:city], address_params[:state])
    render json: temp.forecast_cache
  end

  private

  def address_params
    params.permit(:city, :state)
  end
end
