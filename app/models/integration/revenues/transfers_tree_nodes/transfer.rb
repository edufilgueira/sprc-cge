#
# Representação básica para nós de 'Transferências Obrigatórias' e
# 'Transferências Voluntárias'
#
class Integration::Revenues::TransfersTreeNodes::Transfer < Integration::Revenues::RevenuesTreeNodes::Base

  def nodes
    result = []

    group_resources.each do |group_resource|

      group_resource_accounts = accounts_from_group_resource(group_resource)

      result << {
        resource: group_resource,
        id: group_resource,
        type: :transfer,
        title: transfer_title(group_resource),
        valor_previsto_inicial: valor_previsto_inicial(group_resource_accounts),
        valor_previsto_atualizado: valor_previsto_atualizado(group_resource_accounts),
        valor_arrecadado: valor_arrecadado(group_resource_accounts)
      }
    end

    result
  end

  private

  def group_resources
    return [] if initial_scope.blank?

    [:required, :voluntary]
  end

  def accounts_from_group_resource(group_resource)
    initial_scope.where("integration_supports_revenue_natures.transfer_#{group_resource} = ?", true)
  end

  def transfer_title(group_resource)
    Integration::Supports::RevenueNature.human_attribute_name("transfer_#{group_resource}")
  end
end
