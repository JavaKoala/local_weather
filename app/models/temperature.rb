class Temperature

  def initialize(city, state)
    @city = city.strip
    @state = state.strip
  end

  def coordinates
    search = @city + ', ' + @state
    locations = Geocoder.search(search)
    if locations.empty?
      return locations
    else
      return locations.first.coordinates
    end
  end
end