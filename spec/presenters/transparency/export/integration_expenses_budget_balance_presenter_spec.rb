require 'rails_helper'

describe Transparency::Export::IntegrationExpensesBudgetBalancePresenter do
  subject(:expenses_budget_balance_spreadsheet_presenter) do
    Transparency::Export::IntegrationExpensesBudgetBalancePresenter.new(expenses_budget_balances)
  end

  let(:secretary) { create(:integration_supports_organ, :secretary, orgao_sfp: false) }
  let(:organ) { create(:integration_supports_organ, codigo_entidade: secretary.codigo_entidade, orgao_sfp: false) }

  let(:organ_attributes) do
    {
      cod_unid_gestora: organ.codigo_orgao,
      cod_unid_orcam: organ.codigo_orgao,
      cod_funcao: function.codigo_funcao,
      organ: organ
    }
  end

  let(:expenses_budget_balance) do
    budget_balance = create(:integration_expenses_budget_balance, expense_attributes)
    budget_balance.update(organ_attributes)

    budget_balance
  end

  let(:expense_attributes) do
    {
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

  let(:function) { create(:integration_supports_function) }

  let(:transparency_export) { create(:transparency_export, :expenses_budget_balance) }

  let(:expenses_budget_balance_result_ids) { Integration::Expenses::BudgetBalance.find_by_sql(transparency_export.query).pluck(:id) }

  let(:expenses_budget_balances) { Integration::Expenses::BudgetBalance.where(id: expenses_budget_balance_result_ids) }

  let(:klass) { Integration::Expenses::BudgetBalance }

  let(:columns) do
    [
      :title,
      :calculated_valor_orcamento_atualizado,
      :calculated_valor_empenhado,
      :calculated_valor_liquidado,
      :calculated_valor_pago
    ]
  end

  it 'spreadsheet_header' do
    expected = columns.map{ |column| I18n.t("integration/expenses/budget_balance.spreadsheet.worksheets.default.header.#{column}") }

    expect(Transparency::Export::IntegrationExpensesBudgetBalancePresenter.spreadsheet_header).to eq(expected)
  end


  it 'spreadsheet_row' do
    expenses_budget_balance

    expenses_tree = Integration::Expenses::ExpensesTree.new(expenses_budget_balances)
    nodes = expenses_tree.nodes(:organ)

    expected = [
      nodes.first[:title],
      nodes.first[:calculated_valor_orcamento_atualizado],
      nodes.first[:calculated_valor_empenhado],
      nodes.first[:calculated_valor_liquidado],
      nodes.first[:calculated_valor_pago]
    ]

    result = expenses_budget_balance_spreadsheet_presenter.spreadsheet_row

    expect(result).to eq([expected])
  end
end
