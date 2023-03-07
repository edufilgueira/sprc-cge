require 'rails_helper'

describe Admin::Integrations::Constructions::DaesController do

  let(:user) { create(:user, :admin) }
  let(:dae) { create(:integration_constructions_dae) }

  context 'index' do
    before { sign_in(user) && get(:index) }

    it 'breadcrumbs' do
      expected = [
        { title: I18n.t('admin.home.index.title'), url: admin_root_path },
        { title: I18n.t('admin.integrations.index.title'), url: admin_integrations_root_path },
        { title: I18n.t('shared.transparency.constructions.daes.index.title'), url: '' }
      ]

      expect(controller.breadcrumbs).to eq(expected)
    end
  end

  context 'show' do
    before { sign_in(user) && get(:show, params: { id: dae }) }

    it 'breadcrumbs' do
      expected = [
        { title: I18n.t('admin.home.index.title'), url: admin_root_path },
        { title: I18n.t('admin.integrations.index.title'), url: admin_integrations_root_path },
        { title: I18n.t('shared.transparency.constructions.daes.index.title'), url: admin_integrations_constructions_daes_path },
        { title: dae.title, url: '' }
      ]

      expect(controller.breadcrumbs).to eq(expected)
    end
  end
end
