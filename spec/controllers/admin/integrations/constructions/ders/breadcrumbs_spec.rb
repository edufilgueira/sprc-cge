require 'rails_helper'

describe Admin::Integrations::Constructions::DersController do

  let(:user) { create(:user, :admin) }
  let(:der) { create(:integration_constructions_der) }

  context 'index' do
    before { sign_in(user) && get(:index) }

    it 'breadcrumbs' do
      expected = [
        { title: I18n.t('admin.home.index.title'), url: admin_root_path },
        { title: I18n.t('admin.integrations.index.title'), url: admin_integrations_root_path },
        { title: I18n.t('shared.transparency.constructions.ders.index.title'), url: '' }
      ]

      expect(controller.breadcrumbs).to eq(expected)
    end
  end

  context 'show' do
    before { sign_in(user) && get(:show, params: { id: der }) }

    it 'breadcrumbs' do
      expected = [
        { title: I18n.t('admin.home.index.title'), url: admin_root_path },
        { title: I18n.t('admin.integrations.index.title'), url: admin_integrations_root_path },
        { title: I18n.t('shared.transparency.constructions.ders.index.title'), url: admin_integrations_constructions_ders_path },
        { title: der.title, url: '' }
      ]

      expect(controller.breadcrumbs).to eq(expected)
    end
  end
end
