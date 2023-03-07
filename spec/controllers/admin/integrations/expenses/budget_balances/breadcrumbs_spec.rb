require 'rails_helper'

describe Admin::Integrations::Expenses::BudgetBalancesController  do

  let(:user) { create(:user, :admin) }
  let(:budget_balance) { create(:integration_expenses_budget_balance) }


  context 'index' do
    before { sign_in(user) && get(:index) }

    it 'breadcrumbs' do
      expected = [
        { title: I18n.t('admin.home.index.title'), url: admin_root_path },
        { title: I18n.t('admin.integrations.index.title'), url: admin_integrations_root_path },
        { title: I18n.t('admin.integrations.expenses.index.title'), url: admin_integrations_expenses_root_path },
        { title: I18n.t('admin.integrations.expenses.budget_balances.index.title'), url: '' }
      ]

      expect(controller.breadcrumbs).to eq(expected)
    end
  end
end

