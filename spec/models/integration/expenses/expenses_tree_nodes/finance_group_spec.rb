require 'rails_helper'

describe Integration::Expenses::ExpensesTreeNodes::FinanceGroup do

  let(:secretary) { create(:integration_supports_organ, :secretary, orgao_sfp: false) }
  let(:organ) { create(:integration_supports_organ, codigo_entidade: secretary.codigo_entidade, orgao_sfp: false) }
  let(:function) { create(:integration_supports_function) }
  let(:sub_function) { create(:integration_supports_sub_function) }
  let(:government_action) { create(:integration_supports_government_action) }
  let(:administrative_region) { create(:integration_supports_administrative_region, codigo_regiao: '1500000') }
  let(:expense_nature) { create(:integration_supports_expense_nature) }
  let(:qualified_resource_source) { create(:integration_supports_qualified_resource_source) }
  let(:finance_group) { create(:integration_supports_finance_group) }

  let(:valor_inicial_budget_balance) do
    create(:integration_expenses_budget_balance, valor_inicial_attributes)
  end

  let(:valor_inicial_attributes) do
    {
      cod_unid_gestora: organ.codigo_orgao,
      cod_unid_orcam: organ.codigo_orgao,
      cod_funcao: function.codigo_funcao,
      cod_subfuncao: sub_function.codigo_sub_funcao,
      cod_acao: government_action.codigo_acao,
      cod_localizacao_gasto: administrative_region.codigo_regiao_resumido,
      cod_natureza_desp: expense_nature.codigo_natureza_despesa,
      cod_fonte: qualified_resource_source.codigo,
      cod_grupo_fin: finance_group.codigo_grupo_financeiro,
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
      nodes = Integration::Expenses::ExpensesTreeNodes::FinanceGroup.new(Integration::Expenses::BudgetBalance.none)

      expect(nodes.nodes).to eq([])
    end
  end

  describe 'calculations' do
    it 'returns nodes' do
      valor_inicial_budget_balance

      nodes = Integration::Expenses::ExpensesTreeNodes::FinanceGroup.new(Integration::Expenses::BudgetBalance.all).nodes

      node = nodes.first

      expect(node[:resource]).to eq(finance_group)
      expect(node[:id]).to eq(finance_group.codigo_grupo_financeiro)
      expect(node[:type]).to eq(:finance_group)
      expect(node[:title]).to eq(finance_group.title)

      expect(node[:calculated_valor_orcamento_inicial]).to eq(valor_orcamento_inicial)
      expect(node[:calculated_valor_orcamento_atualizado]).to eq(valor_orcamento_atualizado)
      expect(node[:calculated_valor_empenhado]).to eq(valor_empenhado)
      expect(node[:calculated_valor_liquidado]).to eq(valor_liquidado)
      expect(node[:calculated_valor_pago]).to eq(valor_pago)
    end
  end
end
