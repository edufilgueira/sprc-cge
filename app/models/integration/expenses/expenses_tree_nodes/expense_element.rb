#
# Representação dos nós de elemento de despesa na árvore de despesas.
#
class Integration::Expenses::ExpensesTreeNodes::ExpenseElement < Integration::Expenses::ExpensesTreeNodes::Base

  private

  def resources_with_budget_balances
    resource_ids = initial_scope.
      pluck('DISTINCT integration_expenses_budget_balances.cod_elemento_despesa').uniq.compact

    Integration::Supports::ExpenseElement.where('codigo_elemento_despesa IN (?)', resource_ids)
  end

  def budget_balances_from_resource(resource)
    initial_scope.where('integration_expenses_budget_balances.cod_elemento_despesa = ?', resource.codigo_elemento_despesa)
  end

  def resource_type
    :expense_element
  end

  def resource_id(resource)
    resource.codigo_elemento_despesa
  end
end
