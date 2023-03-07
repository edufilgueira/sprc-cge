#
# Representação dos nós de função na árvore de despesas.
#
class Integration::Expenses::ExpensesTreeNodes::Function < Integration::Expenses::ExpensesTreeNodes::Base

  def nodes
    result = []

    functions_with_budget_balances.each do |function|
      budget_balances = budget_balances_from_function(function)

      result << {
        resource: function,
        id: function.codigo_funcao,
        type: :function,
        title: function.title
      }.merge(nodes_data(budget_balances))
    end

    result
  end

  private

  def functions_with_budget_balances
    function_ids = initial_scope.
      pluck('DISTINCT integration_supports_functions.codigo_funcao').uniq.compact

    Integration::Supports::Function.where('codigo_funcao IN (?)', function_ids)
  end

  def budget_balances_from_function(function)
    initial_scope.where('integration_supports_functions.codigo_funcao = ?', function.codigo_funcao)
  end
end
