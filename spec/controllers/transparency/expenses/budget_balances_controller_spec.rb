require 'rails_helper'

# Comentando os testes pois por enquanto o ano está fixado para 2018
# Deve ser removido, após exister NEDs de 2019
describe Transparency::Expenses::BudgetBalancesController do
  before { create(:stats_expenses_budget_balance, month_start: 1, month_end: 1, month: 0) }

  it_behaves_like 'controllers/transparency/expenses/budget_balances/index'

  let(:secretary) { create(:integration_supports_organ, :secretary, orgao_sfp: false) }
  let(:organ) { create(:integration_supports_organ, codigo_entidade: secretary.codigo_entidade, orgao_sfp: false) }

  let(:current_date) { Date.today.beginning_of_month }
  let(:current_month) { current_date.month }
  let(:current_year) { current_date.year }
  let(:current_ano_mes_competencia) { "#{current_month}-#{current_year}"}

  let(:resource) { create(:integration_expenses_budget_balance, ano_mes_competencia: current_ano_mes_competencia, cod_unid_gestora: organ.codigo_orgao) }

  let(:another_resource) { create(:integration_expenses_budget_balance) }

  let(:resource_filter_param) do
    { 'integration_supports_organ_id': organ.id }
  end

  it_behaves_like 'controllers/transparency/exports/index'
end
