#
# Representação dos nós de natureza de despesas na árvore de despesas.
#
class Integration::Expenses::ExpensesTreeNodes::ExpenseNature < Integration::Expenses::ExpensesTreeNodes::Base

  def nodes
    result = []

    expense_natures_with_budget_balances.each do |expense_nature|
      budget_balances = budget_balances_from_expense_nature(expense_nature)

      result << {
        resource: expense_nature,
        id: expense_nature.codigo_natureza_despesa,
        type: :expense_nature,
        title: expense_nature.title
      }.merge(nodes_data(budget_balances))
    end

    result
  end

  private

  def expense_natures_with_budget_balances
    expense_nature_ids = initial_scope.
      pluck('DISTINCT integration_supports_expense_natures.codigo_natureza_despesa').uniq.compact

    Integration::Supports::ExpenseNature.where('codigo_natureza_despesa IN (?)', expense_nature_ids)
  end

  def budget_balances_from_expense_nature(expense_nature)
    initial_scope.where('integration_supports_expense_natures.codigo_natureza_despesa = ?', expense_nature.codigo_natureza_despesa)
  end
end
