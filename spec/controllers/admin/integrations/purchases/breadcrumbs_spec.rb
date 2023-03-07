require 'rails_helper'

describe Admin::Integrations::PurchasesController do

  let(:user) { create(:user, :admin) }
  let(:purchase) { create(:integration_purchases_purchase) }

  context 'index' do
    before { sign_in(user) && get(:index) }

    it 'breadcrumbs' do
      expected = [
        { title: I18n.t('admin.home.index.title'), url: admin_root_path },
        { title: I18n.t('admin.integrations.index.title'), url: admin_integrations_root_path },
        { title: I18n.t('shared.transparency.purchases.index.title'), url: '' }
      ]

      expect(controller.breadcrumbs).to eq(expected)
    end
  end

  context 'show' do
    before { sign_in(user) && get(:show, params: { id: purchase }) }

    it 'breadcrumbs' do
      expected = [
        { title: I18n.t('admin.home.index.title'), url: admin_root_path },
        { title: I18n.t('admin.integrations.index.title'), url: admin_integrations_root_path },
        { title: I18n.t('shared.transparency.purchases.index.title'), url: admin_integrations_purchases_path },
        { title: purchase.title, url: '' }
      ]

      expect(controller.breadcrumbs).to eq(expected)
    end
  end
end
