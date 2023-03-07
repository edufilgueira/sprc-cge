#
# Representação básica para nós de 'Natureza de Receita', como consolidado,
# categoria_economica...
#
class Integration::Revenues::RevenuesTreeNodes::RevenueNature < Integration::Revenues::RevenuesTreeNodes::Base

  def nodes
    result = []

    group_resources.each do |group_resource|

      group_resource_accounts = accounts_from_revenue_nature(group_resource)

      result << {
        # resource: group_resource,
        id: revenue_nature_id(group_resource),
        type: revenue_nature_type,
        title: group_resource.title,
        valor_previsto_inicial: valor_previsto_inicial(group_resource_accounts),
        valor_previsto_atualizado: valor_previsto_atualizado(group_resource_accounts),
        valor_arrecadado: valor_arrecadado(group_resource_accounts)
      }
    end

    result.uniq
  end

  private

  def group_resources
    unique_ids_select = "DISTINCT integration_supports_revenue_natures.#{unique_id_column_name}"
    unique_ids = initial_scope.pluck(unique_ids_select).compact

    Integration::Supports::RevenueNature.where('unique_id IN (?)', unique_ids)
  end

  def accounts_from_revenue_nature(group_resource)
    initial_scope.where("integration_supports_revenue_natures.#{unique_id_column_name} = ?", group_resource.unique_id)
  end

  def unique_id_column_name
    "unique_id_#{revenue_nature_type}"
  end

  def revenue_nature_id(revenue_nature)
    revenue_nature.send("unique_id_#{revenue_nature_type}")
  end
end
