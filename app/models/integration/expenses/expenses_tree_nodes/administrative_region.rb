#
# Representação dos nós de regiões administrativas na árvore de despesas.
#
class Integration::Expenses::ExpensesTreeNodes::AdministrativeRegion < Integration::Expenses::ExpensesTreeNodes::Base

  def nodes
    result = []

    administrative_regions_with_budget_balances.each do |administrative_region|
      budget_balances = budget_balances_from_administrative_region(administrative_region)

      result << {
        resource: administrative_region,
        id: administrative_region.codigo_regiao_resumido,
        type: :administrative_region,
        title: administrative_region.title
      }.merge(nodes_data(budget_balances))
    end

    result
  end

  private

  def administrative_regions_with_budget_balances
    administrative_region_ids = initial_scope.
      pluck('DISTINCT integration_supports_administrative_regions.codigo_regiao_resumido').uniq.compact

    Integration::Supports::AdministrativeRegion.where('codigo_regiao_resumido IN (?)', administrative_region_ids)
  end

  def budget_balances_from_administrative_region(administrative_region)
    initial_scope.where('integration_supports_administrative_regions.codigo_regiao_resumido = ?', administrative_region.codigo_regiao_resumido)
  end
end
