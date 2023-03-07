#
# Representação dos nós de secretarias na árvore de receitas.
#
class Integration::Revenues::RegisteredRevenuesTreeNodes::Base < Integration::Revenues::RevenuesTreeNodes::Base

  ACCOUNTS = {
    ipva: ['4.1.1.2.1.03.01', '4.1.1.2.1.06'],
    restituicoes_ipva: ['4.1.1.2.1.97.01'],
    deducoes_ipva: ['4.1.1.2.1.97.11']
  }

  private

  def base_scope(scope)
    scope.reorder('')
  end

  ## Meses

  def valor_lancado(revenues)
    sum = revenues_sum(revenues)

    (sum[:ipva] - sum[:restituicoes_ipva] - sum[:deducoes_ipva])
  end

  def revenues_sum(revenues)
    rows = revenues.group(:natureza_da_conta, :conta_contabil).select(revenues_sum_expression)
    result = {
      ipva: 0,
      restituicoes_ipva: 0,
      deducoes_ipva: 0
    }

    rows.each do |row|
      result[:ipva] += row.total_ipva
      result[:restituicoes_ipva] += row.total_restituicoes_ipva
      result[:deducoes_ipva] += row.total_deducoes_ipva
    end

    result
  end

  def revenues_sum_expression

    return @revenues_sum_expression if @revenues_sum_expression.present?

    base_expresion = %Q{
            ( CASE
          WHEN integration_revenues_revenues.natureza_da_conta = 'DÉBITO' AND (integration_revenues_revenues.conta_contabil in %{account_number} ) THEN
            sum(integration_revenues_revenues.valor_inicial) + (sum(integration_revenues_revenues.valor_debito) - sum(integration_revenues_revenues.valor_credito))

          WHEN integration_revenues_revenues.natureza_da_conta = 'CRÉDITO' AND (integration_revenues_revenues.conta_contabil in %{account_number} )  THEN
            sum(integration_revenues_revenues.valor_inicial) + (sum(integration_revenues_revenues.valor_credito) - sum(integration_revenues_revenues.valor_debito))

          ELSE
            0
        END
      ) AS total_%{account_type}
    }

    result = []

    ACCOUNTS.each do |account_type, account_number|

      result << base_expresion % { account_type: account_type, account_number: account_number.to_s.gsub('[', '(').gsub(']', ')').gsub('"',"'") }

    end

    @revenues_sum_expression = result.join(', ')
  end
end
