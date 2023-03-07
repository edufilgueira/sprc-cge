module Transparency::CityUndertakings::Filters
  include Transparency::CreditorsSelectController

  FILTERED_COLUMNS = [
    :organ_id,
    :creditor_id,
    :undertaking_id,
    :municipio,
    :mapp,
    :expense
  ]

  FILTERED_CUSTOM = []

  def filtered_resources
    filtered = filtered(Integration::CityUndertakings::CityUndertaking, sorted_resources)

    # a busca pelo nome do credor no campo 'search_datalist' desconsidera os demais filtros
    return search_by_creditor_name(filtered) if params[:search_datalist].present?

    filtered
  end
end
