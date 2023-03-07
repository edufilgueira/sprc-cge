require 'rails_helper'

describe Admin::Integrations::Supports::CreditorsController do

  let(:user) { create(:user, :admin) }
  let(:creditor) { create(:integration_supports_creditor) }

  context 'index' do
    before { sign_in(user) && get(:index) }

    it 'breadcrumbs' do
      expected = [
        { title: I18n.t('admin.home.index.title'), url: admin_root_path },
        { title: I18n.t('admin.integrations.index.title'), url: admin_integrations_root_path },
        { title: I18n.t('admin.integrations.supports.creditors.index.title'), url: '' }
      ]

      expect(controller.breadcrumbs).to eq(expected)
    end
  end

  context 'show' do
    before { sign_in(user) && get(:show, params: { id: creditor }) }

    it 'breadcrumbs' do
      expected = [
        { title: I18n.t('admin.home.index.title'), url: admin_root_path },
        { title: I18n.t('admin.integrations.index.title'), url: admin_integrations_root_path },
        { title: I18n.t('admin.integrations.supports.creditors.index.title'), url: admin_integrations_supports_creditors_path },
        { title: creditor.title.truncate(20), url: '' }
      ]

      expect(controller.breadcrumbs).to eq(expected)
    end
  end
end
