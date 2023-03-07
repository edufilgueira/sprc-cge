#
# Representação dos nós de sub_função na árvore de despesas.
#
class Integration::Expenses::ExpensesTreeNodes::SubFunction < Integration::Expenses::ExpensesTreeNodes::Base

  def nodes
    result = []

    sub_functions_with_budget_balances.each do |sub_function|
      budget_balances = budget_balances_from_sub_function(sub_function)

      result << {
        resource: sub_function,
        id: sub_function.codigo_sub_funcao,
        type: :sub_function,
        title: sub_function.title
      }.merge(nodes_data(budget_balances))
    end

    result
  end

  private

  def sub_functions_with_budget_balances
    sub_function_ids = initial_scope.
      pluck('DISTINCT integration_supports_sub_functions.codigo_sub_funcao').uniq.compact

    Integration::Supports::SubFunction.where('codigo_sub_funcao IN (?)', sub_function_ids)
  end

  def budget_balances_from_sub_function(sub_function)
    initial_scope.where('integration_supports_sub_functions.codigo_sub_funcao = ?', sub_function.codigo_sub_funcao)
  end
end
