# RESTful API pública de Unidades (Department)
#
# 1) INDEX
#    GET /api/v1/subnets
#    HTTP 200 - [ { role }, { role }, ... ]
#
class Api::V1::SubnetsController < Api::V1::ApplicationController
  include FilteredController

  FILTERED_ASSOCIATIONS = [
    :organ_id
  ]

  # Actions

  def index
    object_response(subnets)
  end

  # Privates

  private

  def subnets
    filtered_subnets
  end

  def filtered_subnets
    filtered(::Subnet, sorted_subnets)
  end

  def sorted_subnets
    resources.sorted
  end

  def resources
    @resources ||= subnets_from_organ
  end

  def subnets_from_organ
    if organ.present?
      organ.subnets.enabled
    else
      Subnet.enabled
    end
  end

  def organ
    @organ ||= Organ.find(params[:organ_id]) if params[:organ_id].present?
  end
end
