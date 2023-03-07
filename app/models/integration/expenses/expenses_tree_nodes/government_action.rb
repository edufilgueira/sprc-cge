#
# Representação dos nós de ações de governo na árvore de despesas.
#
class Integration::Expenses::ExpensesTreeNodes::GovernmentAction < Integration::Expenses::ExpensesTreeNodes::Base

  def nodes
    result = []

    ids = initial_scope.distinct.pluck(:id)

    scope = initial_scope.unscope(:where).unscope(:includes).where('id in (?)', ids).group(:cod_acao)

    data = nodes_data(scope)

    data.each do |datum|
      government_action = Integration::Supports::GovernmentAction.find_by(codigo_acao: datum.cod_acao)

      next if government_action.blank?

      result << {
        resource: government_action,
        id: government_action.codigo_acao,
        type: :government_action,
        title: government_action.title,
        calculated_valor_orcamento_inicial: datum.calculated_valor_orcamento_inicial,
        calculated_valor_orcamento_atualizado: datum.calculated_valor_orcamento_atualizado,
        calculated_valor_empenhado: datum.calculated_valor_empenhado,
        calculated_valor_liquidado: datum.calculated_valor_liquidado,
        calculated_valor_pago: datum.calculated_valor_pago
      }
    end

    result
  end

  # private

  def nodes_data(budget_balances)
    budget_balances_sums = budget_balances.select(%Q{
      cod_acao,
      SUM(calculated_valor_orcamento_inicial) AS calculated_valor_orcamento_inicial,
      SUM(calculated_valor_orcamento_atualizado) AS calculated_valor_orcamento_atualizado,
      SUM(calculated_valor_empenhado) AS calculated_valor_empenhado,
      SUM(calculated_valor_liquidado) AS calculated_valor_liquidado,
      SUM(calculated_valor_pago) AS calculated_valor_pago
    })
  end
end
