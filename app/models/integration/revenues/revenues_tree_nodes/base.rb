#
# Representação básica e compartilhada dos nós da árvore de receitas.
#
class Integration::Revenues::RevenuesTreeNodes::Base

  ACCOUNTS_2018 = {
    previsto_inicial: ['5.2.1.1', '5.2.1.1.1'],
    previsto_adicional: ['5.2.1.2.1', '5.2.1.2.1.0.1', '5.2.1.2.1.0.2'],
    previsto_anulado: ['5.2.1.2.9'],
    receita_corrente: ['6.2.1.2'],
    deducoes_receita: ['6.2.1.3']
  }

  ACCOUNTS_2019 = {
    previsto_inicial: ['5.2.1.1.1'],

    previsto_inicial_anulado: [
      '5.2.1.1.2.01.01', 
      '5.2.1.2.1.03.01'
    ], # * 5.2.1.2.1.03.01 talvez n seja aqui

    previsto_adicional: [
      '5.2.1.2.1.01', 
      '5.2.1.2.1.02',

    ],

    previsto_anulado: [
      '5.2.1.1.2.02',
      '5.2.1.1.2.99',
      '5.2.1.2.1.03.02',
      '5.2.1.2.1.04',
      '5.2.1.2.1.99',
      '5.2.1.2.9'],

    receita_corrente: ['6.2.1.2'],

    deducoes_receita: [
      '6.2.1.3.1.01',
      '6.2.1.3.1.02', 
      '6.2.1.3.2', 
      '6.2.1.3.9.01'
    ]
  }

  ACCOUNTS = {
    #
    # TODO: obter automaticamente pelas contas cadastradas no configurado
    # Integration::Revenues::AccountConfiguration
    #
    # previsto_inicial: ['5.2.1.1', '5.2.1.1.1'],
    # previsto_adicional: ['5.2.1.2.1', '5.2.1.2.1.0.1', '5.2.1.2.1.0.2'],
    # previsto_anulado: ['5.2.1.2.9'],
    # receita_corrente: ['6.2.1.2'],
    # deducoes_receita: ['6.2.1.3']

    previsto_inicial: (ACCOUNTS_2018[:previsto_inicial] + ACCOUNTS_2019[:previsto_inicial]).uniq,
    previsto_inicial_anulado: (ACCOUNTS_2019[:previsto_inicial_anulado]).uniq,
    previsto_adicional: (ACCOUNTS_2018[:previsto_adicional] + ACCOUNTS_2019[:previsto_adicional]).uniq,
    previsto_anulado: (ACCOUNTS_2018[:previsto_anulado] + ACCOUNTS_2019[:previsto_anulado]).uniq,
    receita_corrente: (ACCOUNTS_2018[:receita_corrente] + ACCOUNTS_2019[:receita_corrente]).uniq,
    deducoes_receita: (ACCOUNTS_2018[:deducoes_receita] + ACCOUNTS_2019[:deducoes_receita]).uniq
  }

  attr_reader :initial_scope, :parent_node_path

  def initialize(initial_scope, parent_node_path = nil)
    @initial_scope = scoped_to_parent(initial_scope, parent_node_path)
    @parent_node_path = parent_node_path
  end

  private

  def valor_previsto_inicial(accounts)
    sum = accounts_sum(accounts)

    (sum[:previsto_inicial] - sum[:previsto_inicial_anulado])
  end

  def valor_previsto_atualizado(accounts)
    sum = accounts_sum(accounts)

    ((sum[:previsto_inicial] - sum[:previsto_inicial_anulado])  + sum[:previsto_adicional] - sum[:previsto_anulado])
  end

  def valor_arrecadado(accounts)
    sum = accounts_sum(accounts)

    (sum[:receita_corrente] - sum[:deducoes_receita])
  end

  def accounts_from_account_type(accounts, account_type)
    accounts.where('integration_revenues_revenues.conta_contabil': ACCOUNTS[account_type])
  end

  def accounts_sum(accounts)

    rows = accounts.group(:natureza_da_conta, :conta_contabil).select(accounts_sum_expression)

    result = {
      previsto_inicial: 0,
      previsto_inicial_anulado: 0,
      previsto_adicional: 0,
      previsto_anulado: 0,
      receita_corrente: 0,
      deducoes_receita: 0
    }

    rows.each do |row|
      result[:previsto_inicial] += row.total_previsto_inicial
      result[:previsto_inicial_anulado] += row.total_previsto_inicial_anulado
      result[:previsto_adicional] += row.total_previsto_adicional
      result[:previsto_anulado] += row.total_previsto_anulado
      result[:receita_corrente] += row.total_receita_corrente
      result[:deducoes_receita] += row.total_deducoes_receita
    end

    result
  end

  def accounts_sum_expression

    return @accounts_sum_expression if @accounts_sum_expression.present?

    base_expresion = %Q{
      ( CASE
          WHEN integration_revenues_revenues.natureza_da_conta = 'DÉBITO' AND (integration_revenues_revenues.conta_contabil in (%{conta_contabil})) THEN
            sum(integration_revenues_accounts.valor_inicial) + (sum(integration_revenues_accounts.valor_debito) - sum(integration_revenues_accounts.valor_credito))

          WHEN integration_revenues_revenues.natureza_da_conta = 'CRÉDITO' AND (integration_revenues_revenues.conta_contabil in (%{conta_contabil})) THEN
            sum(integration_revenues_accounts.valor_inicial) + (sum(integration_revenues_accounts.valor_credito) - sum(integration_revenues_accounts.valor_debito))

          ELSE
            0
        END
      ) AS total_%{titulo}
    }

    result = []

    ACCOUNTS.each do |titulo, conta_contabils|
      conta_contabil_range_str = conta_contabils.map { |i| "'" + i.to_s + "'" }.join(',')

      result << base_expresion % { titulo: titulo, conta_contabil: conta_contabil_range_str }
    end

    @accounts_sum_expression = result.join(', ')
  end

  private

  def base_scope(scope)
    scope.joins({ revenue: :organ }, :revenue_nature).reorder('')
  end

  def scoped_to_parent(scope, parent_node_path)
    scope = base_scope(scope)

    return scope if parent_node_path.blank?

    # quebra  "secretary/00200/consolidado/900000000" em
    # [["secretary", "00200"], ["consolidado", "900000000"]]

    parents_path = parent_node_path.split('/').in_groups_of(2)

    parents_path.each do |parent_path|
      # cada parent_path é um array do tipo ["secretary", "00200"]

      node_type, node_id = parent_path

      scope = scoped_to_node(scope, node_type, node_id)
    end

    scope
  end

  def scoped_to_node(scope, node_type, node_id)
    if node_type == 'secretary'
      scope.where('integration_revenues_revenues.integration_supports_secretary_id = ?', node_id)
    elsif node_type == 'organ'
      scope.where('integration_revenues_revenues.integration_supports_organ_id = ?', node_id)
    elsif node_type == 'month'
      # Não aplicamos o filtro aqui pois vamos precisar do valor acumulado e se setarmos o mês,
      # não conseguiremos recuperar os registros menores que ele.
      scope
    elsif node_type == 'transfer'
      scope.where("integration_supports_revenue_natures.transfer_#{node_id} = ?", true)
    else
      scope.where("integration_supports_revenue_natures.unique_id_#{node_type} = ?", node_id)
    end
  end
end
