require 'rails_helper'

describe Admin::Integrations::RealStatesController do

  let(:user) { create(:user, :admin) }
  let(:real_state) { create(:integration_real_states_real_state) }

  context 'index' do
    before { sign_in(user) && get(:index) }

    it 'breadcrumbs' do
      expected = [
        { title: I18n.t('admin.home.index.title'), url: admin_root_path },
        { title: I18n.t('admin.integrations.index.title'), url: admin_integrations_root_path },
        { title: I18n.t('shared.transparency.real_states.index.title'), url: '' }
      ]

      expect(controller.breadcrumbs).to eq(expected)
    end
  end

  context 'show' do
    before { sign_in(user) && get(:show, params: { id: real_state }) }

    it 'breadcrumbs' do
      expected = [
        { title: I18n.t('admin.home.index.title'), url: admin_root_path },
        { title: I18n.t('admin.integrations.index.title'), url: admin_integrations_root_path },
        { title: I18n.t('shared.transparency.real_states.index.title'), url: admin_integrations_real_states_path },
        { title: real_state.title, url: '' }
      ]

      expect(controller.breadcrumbs).to eq(expected)
    end
  end
end
