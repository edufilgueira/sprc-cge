module CitiesHelper

  def cities_by_state_for_select(state_id)
    cities = City.where(state: state_id).sorted
    cities.pluck(:name, :id)
  end

end
