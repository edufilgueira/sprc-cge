require 'rails_helper'

describe Integration::Expenses::ExpensesTreeNodes::Organ do

  let(:secretary) { create(:integration_supports_organ, :secretary, orgao_sfp: false) }
  let(:organ) { create(:integration_supports_organ, codigo_entidade: secretary.codigo_entidade, orgao_sfp: false) }

  let(:function) { create(:integration_supports_function) }

  let(:valor_inicial_budget_balance) do
    create(:integration_expenses_budget_balance, valor_inicial_attributes)
  end

  let(:valor_inicial_attributes) do
    {
      cod_unid_gestora: organ.codigo_orgao,
      cod_unid_orcam: organ.codigo_orgao,
      cod_funcao: function.codigo_funcao,
      valor_inicial: 100,
      valor_suplementado: 200,
      valor_anulado: 25,
      valor_empenhado: 125,
      valor_empenhado_anulado: 25,
      valor_liquidado: 50,
      valor_liquidado_anulado: 25,
      valor_pago: 75,
      valor_pago_anulado: 25,
      valor_liquidado_retido: 3,
      valor_liquidado_retido_anulado: 1
    }
  end

  # Esperado:

  let(:valor_orcamento_inicial) do
    valor_inicial_attributes[:valor_inicial]
  end

  let(:valor_orcamento_atualizado) do
    (valor_inicial_attributes[:valor_inicial] + valor_inicial_attributes[:valor_suplementado] - valor_inicial_attributes[:valor_anulado])
  end

  let(:valor_empenhado) do
    (valor_inicial_attributes[:valor_empenhado] - valor_inicial_attributes[:valor_empenhado_anulado])
  end

  let(:valor_liquidado) do
    (valor_inicial_attributes[:valor_liquidado] - valor_inicial_attributes[:valor_liquidado_anulado])
  end

  let(:valor_pago) do
    (valor_inicial_attributes[:valor_pago] - valor_inicial_attributes[:valor_pago_anulado]) +
    (valor_inicial_attributes[:valor_liquidado_retido] - valor_inicial_attributes[:valor_liquidado_retido_anulado])
  end

  describe 'initialization' do
    it 'returns empty array for empty scope' do
      nodes = Integration::Expenses::ExpensesTreeNodes::Organ.new(Integration::Expenses::BudgetBalance.none)

      expect(nodes.nodes).to eq([])
    end
  end

  describe 'calculations' do

    it 'returns nodes' do

      valor_inicial_budget_balance

      nodes = Integration::Expenses::ExpensesTreeNodes::Organ.new(Integration::Expenses::BudgetBalance.all).nodes

      node = nodes.first

      expect(node[:resource]).to eq(organ)
      expect(node[:id]).to eq(organ.id)
      expect(node[:type]).to eq(:organ)
      expect(node[:title]).to eq(organ.title)
      expect(node[:calculated_valor_orcamento_inicial]).to eq(valor_orcamento_inicial)
      expect(node[:calculated_valor_orcamento_atualizado]).to eq(valor_orcamento_atualizado)
      expect(node[:calculated_valor_empenhado]).to eq(valor_empenhado)
      expect(node[:calculated_valor_liquidado]).to eq(valor_liquidado)
      expect(node[:calculated_valor_pago]).to eq(valor_pago)
    end
  end

  #
  # Permite passar um path do parent para que as contas sejam filtradas.
  # Ex: secretary/426
  # Irá retornar os nós de órgãos da árvore de despesas que forem da secretary com codigo 426.
  # Ex: secretary/426/organ/100000000 (da unidade gestora 426 e que a unidade orcamentaria seja 1000000)
  #
  describe 'parent_node_path' do

    let(:another_secretary) { create(:integration_supports_organ, :secretary, orgao_sfp: false) }
    let(:another_organ) { create(:integration_supports_organ, codigo_entidade: another_secretary.codigo_entidade, orgao_sfp: false) }

    let(:another_function) { create(:integration_supports_function) }

    let(:another_valor_inicial_budget_balance) do
      create(:integration_expenses_budget_balance, another_valor_inicial_attributes)
    end

    let(:another_valor_inicial_attributes) do
      valor_inicial_attributes.merge({
        cod_unid_gestora: another_organ.codigo_orgao,
        cod_unid_orcam: another_organ.codigo_orgao,
        cod_funcao: another_function.codigo_funcao,
        valor_inicial: 100,
        valor_suplementado: 200,
        valor_anulado: 25,
        valor_empenhado: 125,
        valor_empenhado_anulado: 25,
        valor_liquidado: 50,
        valor_liquidado_anulado: 25,
        valor_pago: 75,
        valor_pago_anulado: 25
      })
    end

    it 'returns nodes from parent' do
      valor_inicial_budget_balance
      another_valor_inicial_budget_balance

      nodes = Integration::Expenses::ExpensesTreeNodes::Organ.new(Integration::Expenses::BudgetBalance.all).nodes

      # Todos os nós.
      expect(nodes.count).to eq(2)

      # Apenas os nós de determinada unidade gestora.
      parent_path = "secretary/#{another_secretary.id}"
      nodes = Integration::Expenses::ExpensesTreeNodes::Organ.new(Integration::Expenses::BudgetBalance.all, parent_path).nodes

      expect(nodes.count).to eq(1)

      node = nodes.first

      expect(node[:resource]).to eq(another_organ)
      expect(node[:calculated_valor_orcamento_inicial]).to eq(valor_orcamento_inicial)
      expect(node[:calculated_valor_orcamento_atualizado]).to eq(valor_orcamento_atualizado)
      expect(node[:calculated_valor_empenhado]).to eq(valor_empenhado)
      expect(node[:calculated_valor_liquidado]).to eq(valor_liquidado)
      expect(node[:calculated_valor_pago]).to eq(valor_pago)
    end

    it 'returns nodes from multiple parents' do
      valor_inicial_budget_balance
      another_valor_inicial_budget_balance

      nodes = Integration::Expenses::ExpensesTreeNodes::Organ.new(Integration::Expenses::BudgetBalance.all).nodes

      # Todos os nós.
      expect(nodes.count).to eq(2)

      # Apenas os nós de determinada unidade gestora e determinada função
      parent_path = "secretary/#{another_secretary.id}/function/#{another_function.codigo_funcao}"
      nodes = Integration::Expenses::ExpensesTreeNodes::Organ.new(Integration::Expenses::BudgetBalance.all, parent_path).nodes

      expect(nodes.count).to eq(1)

      node = nodes.first

      expect(node[:resource]).to eq(another_organ)
      expect(node[:calculated_valor_orcamento_inicial]).to eq(valor_orcamento_inicial)
      expect(node[:calculated_valor_orcamento_atualizado]).to eq(valor_orcamento_atualizado)
      expect(node[:calculated_valor_empenhado]).to eq(valor_empenhado)
      expect(node[:calculated_valor_liquidado]).to eq(valor_liquidado)
      expect(node[:calculated_valor_pago]).to eq(valor_pago)
    end
  end
end
