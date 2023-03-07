require 'rails_helper'

describe Transparency::Revenues::AccountsController do
  before { create(:stats_revenues_account, month: 0, month_start: 1, month_end: 1) }
  it_behaves_like 'controllers/transparency/revenues/accounts/index'

  describe '#index respond_to xlsx format' do

    let(:resource) { create(:integration_revenues_account, revenue: revenue, mes: current_month, conta_corrente: "#{revenue_nature.codigo}.20500") }
    let(:another_resource) { create(:integration_revenues_account) }
    let(:secretary) { create(:integration_supports_organ, :secretary, orgao_sfp: false) }
    let(:organ) { create(:integration_supports_organ, orgao_sfp: false, codigo_entidade: secretary.codigo_entidade) }
    let(:revenue) { create(:integration_revenues_revenue, month: current_month, year: current_year, unidade: organ.codigo_orgao, secretary: secretary) }
    let(:revenue_nature) { create(:integration_supports_revenue_nature, codigo: '112109953')}
    let(:current_date) { Date.today.beginning_of_month }
    let(:current_month) { current_date.month }
    let(:current_year) { current_date.year }

    let(:resource_filter_param) do
      { 'integration_revenues_revenues.integration_supports_secretary_id': secretary.id }
    end

    it_behaves_like 'controllers/transparency/exports/index'
  end
end
