#
# Representação dos nós de programa de governo na árvore de despesas.
#
class Integration::Expenses::ExpensesTreeNodes::GovernmentProgram < Integration::Expenses::ExpensesTreeNodes::Base

  private

  def resources_with_budget_balances
    resource_ids = initial_scope.
      pluck('DISTINCT integration_expenses_budget_balances.integration_supports_government_program_id').uniq.compact

    Integration::Supports::GovernmentProgram.where('id IN (?)', resource_ids)
  end

  def budget_balances_from_resource(resource)
    initial_scope.where('integration_expenses_budget_balances.integration_supports_government_program_id = ?', resource.id)
  end

  def resource_type
    :government_program
  end
end
