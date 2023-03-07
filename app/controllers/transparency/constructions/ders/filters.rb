module Transparency::Constructions::Ders::Filters
  include Transparency::BaseFilters

  FILTERED_COLUMNS = [
    :der_status,
    :trecho,
    :distrito
  ]

  FILTERED_CUSTOM = [
    :data_fim_previsto,
    :data_fim_contrato
  ]

  def filtered_resources
    filtered = filtered(Integration::Constructions::Der, sorted_resources)
    filtered = filtered_by_data_fim_previsto(filtered, params_data_fim_previsto)
    filtered_by_data_fim_contrato(filtered, params_data_fim_contrato)
  end

  def filtered_by_data_fim_previsto(scope, date_range)
    filtered_by_date_range(:data_fim_previsto, scope, date_range)
  end

  def filtered_by_data_fim_contrato(scope, date_range)
    filtered_by_date_range(:data_fim_contrato, scope, date_range)
  end

end
