require 'rails_helper'

describe Admin::Integrations::Expenses::NpfsController  do

  let(:user) { create(:user, :admin) }
  let(:npf) { create(:integration_expenses_npf) }


  context 'index' do
    before { sign_in(user) && get(:index) }

    it 'breadcrumbs' do
      expected = [
        { title: I18n.t('admin.home.index.title'), url: admin_root_path },
        { title: I18n.t('admin.integrations.index.title'), url: admin_integrations_root_path },
        { title: I18n.t('admin.integrations.expenses.index.title'), url: admin_integrations_expenses_root_path },
        { title: I18n.t('admin.integrations.expenses.npfs.index.title'), url: '' }
      ]

      expect(controller.breadcrumbs).to eq(expected)
    end
  end

  context 'show' do
    before { sign_in(user) && get(:show, params: { id: npf }) }

    it 'breadcrumbs' do
      expected = [
        { title: I18n.t('admin.home.index.title'), url: admin_root_path },
        { title: I18n.t('admin.integrations.index.title'), url: admin_integrations_root_path },
        { title: I18n.t('admin.integrations.expenses.index.title'), url: admin_integrations_expenses_root_path },
        { title: I18n.t('admin.integrations.expenses.npfs.index.title'), url: admin_integrations_expenses_npfs_path },
        { title: npf.title, url: '' }
      ]

      expect(controller.breadcrumbs).to eq(expected)
    end
  end

end

