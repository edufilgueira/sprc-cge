require 'rails_helper'

describe Admin::Integrations::Contracts::ConvenantsController do

  let(:user) { create(:user, :admin) }
  let(:convenant) { create(:integration_contracts_convenant) }

  context 'index' do
    before { sign_in(user) && get(:index) }

    it 'breadcrumbs' do
      expected = [
        { title: I18n.t('admin.home.index.title'), url: admin_root_path },
        { title: I18n.t('admin.integrations.index.title'), url: admin_integrations_root_path },
        { title: I18n.t('shared.transparency.contracts.convenants.index.title'), url: '' }
      ]

      expect(controller.breadcrumbs).to eq(expected)
    end
  end

  context 'show' do
    before { sign_in(user) && get(:show, params: { id: convenant }) }

    it 'breadcrumbs' do
      expected = [
        { title: I18n.t('admin.home.index.title'), url: admin_root_path },
        { title: I18n.t('admin.integrations.index.title'), url: admin_integrations_root_path },
        { title: I18n.t('shared.transparency.contracts.convenants.index.title'), url: admin_integrations_contracts_convenants_path },
        { title: convenant.title, url: '' }
      ]

      expect(controller.breadcrumbs).to eq(expected)
    end
  end
end
