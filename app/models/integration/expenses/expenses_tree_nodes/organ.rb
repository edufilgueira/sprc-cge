#
# Representação dos nós de unidade orçamentária na árvore de despesas.
#
class Integration::Expenses::ExpensesTreeNodes::Organ < Integration::Expenses::ExpensesTreeNodes::Base

  def nodes
    result = []

    organs_with_budget_balances.each do |organ|
      budget_balances = budget_balances_from_organ(organ)

      result << {
        resource: organ,
        id: organ.id,
        type: :organ,
        title: organ.title
      }.merge(nodes_data(budget_balances))
    end

    result
  end

  private

  def organs_with_budget_balances
    organ_ids = initial_scope.
      pluck('DISTINCT integration_expenses_budget_balances.integration_supports_organ_id').uniq.compact

    Integration::Supports::Organ.where('id IN (?)', organ_ids)
  end

  def budget_balances_from_organ(organ)
    initial_scope.where('integration_expenses_budget_balances.integration_supports_organ_id': organ.id)
  end
end
