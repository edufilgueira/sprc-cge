#
# Representação dos nós de secretarias na árvore de receitas.
#
class Integration::Expenses::ExpensesTreeNodes::Secretary < Integration::Expenses::ExpensesTreeNodes::Base

  def nodes
    result = []

    secretaries_with_budget_balances.each do |secretary|
      budget_balances = budget_balances_from_secretary(secretary)

      result << {
        resource: secretary,
        id: secretary.id,
        type: :secretary,
        title: secretary.title
      }.merge(nodes_data(budget_balances))
    end

    result
  end

  private

  ## Secretarias

  def secretaries_with_budget_balances
    organ_ids = initial_scope.
      pluck('DISTINCT integration_expenses_budget_balances.integration_supports_secretary_id').uniq.compact

    Integration::Supports::Organ.where('id IN (?)', organ_ids)
  end

  def budget_balances_from_secretary(secretary)
    initial_scope.where('integration_expenses_budget_balances.integration_supports_secretary_id = ?', secretary.id)
  end
end
