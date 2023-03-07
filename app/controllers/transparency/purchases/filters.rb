module Transparency::Purchases::Filters
  include Transparency::BaseFilters

  FILTERED_COLUMNS = [
    :manager_id,
    :sistematica_aquisicao,
    :forma_aquisicao,
    :natureza_aquisicao,
    :tipo_aquisicao,
    :nome_fornecedor
  ]

  FILTERED_CUSTOM = [
    :data_publicacao,
    :data_finalizada
  ]

  def filtered_resources
    filtered = filtered(Integration::Purchases::Purchase, sorted_resources)
    filtered = filtered_by_data_publicacao(filtered, params_data_publicacao)
    filtered_by_data_finalizada(filtered, params_data_finalizada)
  end

  def filtered_by_data_publicacao(scope, date_range)
    filtered_by_date_range(:data_publicacao, scope, date_range)
  end

  def filtered_by_data_finalizada(scope, date_range)
    filtered_by_date_range(:data_finalizada, scope, date_range)
  end
end
