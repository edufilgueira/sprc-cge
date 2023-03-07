#
# Representação dos nós de modalidade de aplicação na árvore de despesas.
#
class Integration::Expenses::ExpensesTreeNodes::ApplicationModality < Integration::Expenses::ExpensesTreeNodes::Base

  private

  def resources_with_budget_balances
    resource_ids = initial_scope.
      pluck('DISTINCT integration_expenses_budget_balances.cod_modalidade_aplicacao').uniq.compact

    Integration::Supports::ApplicationModality.where('codigo_modalidade IN (?)', resource_ids)
  end

  def budget_balances_from_resource(resource)
    initial_scope.where('integration_expenses_budget_balances.cod_modalidade_aplicacao = ?', resource.codigo_modalidade)
  end

  def resource_type
    :application_modality
  end

  def resource_id(resource)
    resource.codigo_modalidade
  end
end
