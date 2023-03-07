module Transparency::RealStates::Filters

  FILTERED_COLUMNS = [
    :manager_id,
    :property_type_id,
    :occupation_type_id,
    :municipio,
    :bairro
  ]

  FILTERED_CUSTOM = []

  def filtered_resources
    filtered(Integration::RealStates::RealState, sorted_resources)
  end

end
