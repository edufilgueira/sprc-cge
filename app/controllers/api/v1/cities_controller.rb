# RESTful API pública de cidades por estado
#
# 1) INDEX
#    GET /api/v1/cities
#    HTTP 200 - [ { city }, { city }, ... ]
#
class Api::V1::CitiesController < Api::V1::ApplicationController

  def index
    object_response(sorted_resources)
  end

  private

  def sorted_resources
    resources.sorted
  end

  def resources
    @resources ||= City.where(state: state)
  end

  def state
    params[:state]
  end

end
