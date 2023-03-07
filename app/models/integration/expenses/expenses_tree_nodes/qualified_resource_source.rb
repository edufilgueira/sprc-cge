#
# Representação dos nós de fonte de recurso na árvore de despesas.
#
class Integration::Expenses::ExpensesTreeNodes::QualifiedResourceSource < Integration::Expenses::ExpensesTreeNodes::Base

  def nodes
    result = []

    qualified_resource_sources_with_budget_balances.each do |qualified_resource_source|
      budget_balances = budget_balances_from_qualified_resource_source(qualified_resource_source)

      result << {
        resource: qualified_resource_source,
        id: qualified_resource_source.codigo,
        type: :qualified_resource_source,
        title: qualified_resource_source.title
      }.merge(nodes_data(budget_balances))
    end

    result
  end

  private

  def qualified_resource_sources_with_budget_balances
    qualified_resource_source_ids = initial_scope.
      pluck('DISTINCT integration_supports_qualified_resource_sources.codigo').uniq.compact

    Integration::Supports::QualifiedResourceSource.where('codigo IN (?)', qualified_resource_source_ids)
  end

  def budget_balances_from_qualified_resource_source(qualified_resource_source)
    initial_scope.where('integration_supports_qualified_resource_sources.codigo = ?', qualified_resource_source.codigo)
  end
end
