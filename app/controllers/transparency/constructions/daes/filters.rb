module Transparency::Constructions::Daes::Filters
  include Transparency::BaseFilters

  FILTERED_ASSOCIATIONS = [
    :organ_id
  ]

  FILTERED_COLUMNS = [
    :dae_status,
    :municipio
  ]

  FILTERED_CUSTOM = [
    :data_inicio,
    :data_fim_previsto
  ]

  def filtered_resources
    filtered = filtered(Integration::Constructions::Dae, sorted_resources)
    filtered = filtered_by_data_inicio(filtered, params_data_inicio)
    filtered_by_data_fim_previsto(filtered, params_data_fim_previsto)
  end

  def filtered_by_data_fim_previsto(scope, date_range)
    filtered_by_date_range(:data_fim_previsto, scope, date_range)
  end

  def filtered_by_data_inicio(scope, date_range)
    filtered_by_date_range(:data_inicio, scope, date_range)
  end
end
