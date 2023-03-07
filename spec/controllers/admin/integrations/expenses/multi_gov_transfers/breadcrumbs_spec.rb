require 'rails_helper'

describe Admin::Integrations::Expenses::MultiGovTransfersController  do

  let(:user) { create(:user, :admin) }
  let(:multi_gov_transfer) { create(:integration_expenses_multi_gov_transfer) }


  context 'index' do
    before { sign_in(user) && get(:index) }

    it 'breadcrumbs' do
      expected = [
        { title: I18n.t('admin.home.index.title'), url: admin_root_path },
        { title: I18n.t('admin.integrations.index.title'), url: admin_integrations_root_path },
        { title: I18n.t('admin.integrations.expenses.index.title'), url: admin_integrations_expenses_root_path },
        { title: I18n.t('admin.integrations.expenses.multi_gov_transfers.index.title'), url: '' }
      ]

      expect(controller.breadcrumbs).to eq(expected)
    end
  end

  context 'show' do
    before { get(:show, params: { id: multi_gov_transfer }) }

    it 'breadcrumbs' do
      expected = [
        { title: I18n.t('admin.home.index.title'), url: admin_root_path },
        { title: I18n.t('admin.integrations.index.title'), url: admin_integrations_root_path },
        { title: I18n.t('admin.integrations.expenses.index.title'), url: admin_integrations_expenses_root_path },
        { title: I18n.t('admin.integrations.expenses.multi_gov_transfers.index.title'), url: admin_integrations_expenses_multi_gov_transfers_path },
        { title: multi_gov_transfer.title, url: '' }
      ]

      expect(controller.breadcrumbs).to eq(expected)
    end
  end
end

