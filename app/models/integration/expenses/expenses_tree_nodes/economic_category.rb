#
# Representação dos nós de categoria economica na árvore de despesas.
#
class Integration::Expenses::ExpensesTreeNodes::EconomicCategory < Integration::Expenses::ExpensesTreeNodes::Base

  private

  def resources_with_budget_balances
    resource_ids = initial_scope.
      pluck('DISTINCT integration_expenses_budget_balances.cod_categoria_economica').uniq.compact

    Integration::Supports::EconomicCategory.where('codigo_categoria_economica IN (?)', resource_ids)
  end

  def budget_balances_from_resource(resource)
    initial_scope.where('integration_expenses_budget_balances.cod_categoria_economica = ?', resource.codigo_categoria_economica)
  end

  def resource_type
    :economic_category
  end

  def resource_id(resource)
    resource.codigo_categoria_economica
  end
end
