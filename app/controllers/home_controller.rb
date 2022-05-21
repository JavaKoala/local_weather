class HomeController < ApplicationController
  def index; end

  def show
    if address_params[:city].blank? || address_params[:state].blank?
      return render plain: 'unprocessable_entity', status: :unprocessable_entity
    end

    temp = Temperature.new(address_params[:city], address_params[:state])
    render json: temp.forecast_cache
  end

  private

  def address_params
    params.permit(:city, :state)
  end
end
