#
# Representação dos nós de grupo financeiro na árvore de despesas.
#
class Integration::Expenses::ExpensesTreeNodes::FinanceGroup < Integration::Expenses::ExpensesTreeNodes::Base

  def nodes
    result = []

    finance_groups_with_budget_balances.each do |finance_group|
      budget_balances = budget_balances_from_finance_group(finance_group)

      result << {
        resource: finance_group,
        id: finance_group.codigo_grupo_financeiro,
        type: :finance_group,
        title: finance_group.title
      }.merge(nodes_data(budget_balances))
    end

    result
  end

  private

  def finance_groups_with_budget_balances
    finance_group_ids = initial_scope.
      pluck('DISTINCT integration_supports_finance_groups.codigo_grupo_financeiro').uniq.compact

    Integration::Supports::FinanceGroup.where('codigo_grupo_financeiro IN (?)', finance_group_ids)
  end

  def budget_balances_from_finance_group(finance_group)
    initial_scope.where('integration_supports_finance_groups.codigo_grupo_financeiro = ?', finance_group.codigo_grupo_financeiro)
  end
end
