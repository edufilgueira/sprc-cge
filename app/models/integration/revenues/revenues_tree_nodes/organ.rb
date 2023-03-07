#
# Representação dos nós de órgãos na árvore de receitas.
#
class Integration::Revenues::RevenuesTreeNodes::Organ < Integration::Revenues::RevenuesTreeNodes::Base

  def nodes
    result = []

    organs_with_accounts.each do |organ|

      organ_accounts = accounts_from_organ(organ)

      result << {
        resource: organ,
        id: organ.id,
        type: :organ,
        title: organ.title,
        valor_previsto_inicial: valor_previsto_inicial(organ_accounts),
        valor_previsto_atualizado: valor_previsto_atualizado(organ_accounts),
        valor_arrecadado: valor_arrecadado(organ_accounts)
      }
    end

    result
  end

  private

  def organs_with_accounts
    organ_ids = initial_scope.
      pluck('DISTINCT integration_revenues_revenues.integration_supports_organ_id').uniq.compact

    Integration::Supports::Organ.where('id IN (?)', organ_ids)
  end

  def accounts_from_organ(organ)
    initial_scope.where('integration_revenues_revenues.integration_supports_organ_id': organ.id)
  end
end
