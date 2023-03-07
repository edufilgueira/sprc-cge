require 'rails_helper'

describe Integration::Expenses::ExpensesTreeNodes::Secretary do
  describe 'initialization' do
    it 'returns empty array for empty scope' do
      nodes = Integration::Expenses::ExpensesTreeNodes::Secretary.new(Integration::Expenses::BudgetBalance.none)

      expect(nodes.nodes).to eq([])
    end
  end

  describe 'calculations' do
    let(:secretary) { create(:integration_supports_organ, :secretary) }

    let(:another_secretary) { create(:integration_supports_organ, :secretary) }

    let(:valor_inicial_budget_balance) do
      create(:integration_expenses_budget_balance, valor_inicial_attributes)
    end

    let(:valor_inicial_attributes) do
      {
        cod_unid_gestora: secretary.codigo_orgao,
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

    it 'returns nodes' do

      valor_inicial_budget_balance

      expect(valor_inicial_budget_balance.secretary).to eq(secretary)

      # Esperado:

      valor_orcamento_inicial = valor_inicial_attributes[:valor_inicial]
      valor_orcamento_atualizado = (valor_inicial_attributes[:valor_inicial] + valor_inicial_attributes[:valor_suplementado] - valor_inicial_attributes[:valor_anulado])
      valor_empenhado = (valor_inicial_attributes[:valor_empenhado] - valor_inicial_attributes[:valor_empenhado_anulado])
      valor_liquidado = (valor_inicial_attributes[:valor_liquidado] - valor_inicial_attributes[:valor_liquidado_anulado])
      valor_pago = (valor_inicial_attributes[:valor_pago] - valor_inicial_attributes[:valor_pago_anulado]) + (valor_inicial_attributes[:valor_liquidado_retido] - valor_inicial_attributes[:valor_liquidado_retido_anulado])

      nodes = Integration::Expenses::ExpensesTreeNodes::Secretary.new(Integration::Expenses::BudgetBalance.all).nodes

      node = nodes.first

      expect(node[:resource]).to eq(secretary)
      expect(node[:id]).to eq(secretary.id)
      expect(node[:type]).to eq(:secretary)
      expect(node[:title]).to eq(secretary.title)
      expect(node[:calculated_valor_orcamento_inicial]).to eq(valor_orcamento_inicial)
      expect(node[:calculated_valor_orcamento_atualizado]).to eq(valor_orcamento_atualizado)
      expect(node[:calculated_valor_empenhado]).to eq(valor_empenhado)
      expect(node[:calculated_valor_liquidado]).to eq(valor_liquidado)
      expect(node[:calculated_valor_pago]).to eq(valor_pago)
    end
  end
end
