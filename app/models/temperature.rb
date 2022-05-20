class Temperature
  def initialize(city, state)
    @city = city.strip
    @state = state.strip
  end

  def forecast_cache
    result = { cache_hit: true }

    cache_key = Digest::SHA1.hexdigest @city + @state
    result[:forecast] = Rails.cache.fetch(cache_key, expires_in: 30.minutes) do
      result[:cache_hit] = false
      forecast
    end

    result
  end

  def forecast
    coor = coordinates
    return [] if coor.blank?

    grid_url = points_url(coor[0], coor[1])
    forecast_url = grid_endpoint(grid_url)
    return [] if forecast_url.blank?

    grid_forecast(forecast_url)
  rescue StandardError => e
    Rails.logger.warn e.message
    []
  end

  def coordinates
    search = @city + ', ' + @state
    locations = Geocoder.search(search)

    if locations.empty?
      locations
    else
      locations.first.coordinates
    end
  end

  def points_url(lat, lon)
    "https://api.weather.gov/points/#{lat.round(4)},#{lon.round(4)}"
  end

  def grid_endpoint(points_url)
    result = Faraday.get points_url

    if result.status != 200
      ''
    else
      json_body = JSON.parse(result.body)
      json_body.dig('properties', 'forecast')
    end
  end

  def grid_forecast(forecast_url)
    result = Faraday.get forecast_url

    if result.status != 200
      ''
    else
      json_body = JSON.parse(result.body)
      json_body.dig('properties', 'periods')
    end
  end
end
