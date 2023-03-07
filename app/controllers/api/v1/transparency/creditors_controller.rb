class Api::V1::Transparency::CreditorsController < Api::V1::ApplicationController
  include FilteredController

  GROUPS_MODELS = {
    'default' => ::Integration::Supports::Creditor,
    'contracts' => ::Integration::Contracts::Contract,
    'convenants' => ::Integration::Contracts::Convenant,
    'management_contracts' => ::Integration::Contracts::ManagementContract,
    'city_transfers' => ::Integration::Expenses::CityTransfer,
    'consortium_transfers' => ::Integration::Expenses::ConsortiumTransfer,
    'dailies' => ::Integration::Expenses::Daily,
    'multi_gov_transfers' => ::Integration::Expenses::MultiGovTransfer,
    'neds' => ::Integration::Expenses::Ned,
    'non_profit_transfers' => ::Integration::Expenses::NonProfitTransfer,
    'profit_transfers' => ::Integration::Expenses::ProfitTransfer
  }

  USE_DEFAULT_SORT_SCOPE_FOR = [ 'dailies' ]

  def search
    return object_response([]) unless params_creditor_name.present?

    object_response(filtered_results.to_json)
  end


  # private

  private

  def filtered_results
    # Algumas consultas possuem uma coluna explítica para credores, como
    # contracts.descricao_nome_credor. Esse comportamento está no método de
    # classe 'creditors_name_column'.
    #
    # Portanto, essa API deve procurar no DISTINCT dessa coluna, sendo que o
    # padrão é integration_supports_creditors.nome

    group_model = GROUPS_MODELS[params_group]

    if group_model.present?
      results = filtered_creditors(group_model).distinct.pluck(group_model.creditors_name_column)

      results.map {|result| { nome: result }}
    else
      []
    end
  end

  def filtered_creditors(group_model)
    sql = %Q{
      unaccent(LOWER(#{group_model.creditors_name_column})) LIKE unaccent(LOWER(:search))
    }

    search = "%#{like_search_term}%"

    if USE_DEFAULT_SORT_SCOPE_FOR.include?(params_group)
      group_model.default_sort_scope
    else
      group_model
    end.where(sql, search: search)
  end

  def params_creditor_name
    params[:nome] || ''
  end

  def params_group
    params[:group] || 'default'
  end

  def like_search_term
    cleared_search_term = params_creditor_name.to_s.gsub(/[^[:print:]]/,'%')

    cleared_search_term.tr(' ', '%')
  end
end
