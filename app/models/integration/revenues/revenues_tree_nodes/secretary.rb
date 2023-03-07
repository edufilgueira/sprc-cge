#
# Representação dos nós de secretarias na árvore de receitas.
#
class Integration::Revenues::RevenuesTreeNodes::Secretary < Integration::Revenues::RevenuesTreeNodes::Base

  def nodes
    result = []
    secretaries_with_accounts.each do |secretary|
      result << {
        resource: secretary,
        id: secretary.id,
        type: :secretary,
        title: secretary.title
      }.merge(nodes_data(secretary))
    end

    result
  end

  private

  ## Secretarias

  def nodes_data(secretary)
    secretary_accounts = accounts_from_secretary(secretary)

    result = {
      valor_previsto_inicial: valor_previsto_inicial(secretary_accounts),
      valor_previsto_atualizado: valor_previsto_atualizado(secretary_accounts),
      valor_arrecadado: valor_arrecadado(secretary_accounts)
    }

    result
  end

  def secretaries_with_accounts
    organ_ids = initial_scope.
      pluck('DISTINCT integration_revenues_revenues.integration_supports_secretary_id').uniq.compact

    Integration::Supports::Organ.where('id IN (?)', organ_ids)
  end

  def accounts_from_secretary(secretary)
    initial_scope.where('integration_revenues_revenues.integration_supports_secretary_id = ?', secretary.id)
  end
end
