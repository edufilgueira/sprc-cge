require 'rails_helper'

describe Admin::Integrations::ServerSalariesController do

  let(:user) { create(:user, :admin) }
  let(:server_salary) { create(:integration_servers_server_salary) }

  context 'index' do
    before { sign_in(user) && get(:index) }

    it 'breadcrumbs' do
      expected = [
        { title: I18n.t('admin.home.index.title'), url: admin_root_path },
        { title: I18n.t('admin.integrations.index.title'), url: admin_integrations_root_path },
        { title: I18n.t('shared.transparency.server_salaries.index.title'), url: '' }
      ]

      expect(controller.breadcrumbs).to eq(expected)
    end
  end

  context 'show' do
    before { sign_in(user) && get(:show, params: { id: server_salary }) }

    it 'breadcrumbs' do
      expected = [
        { title: I18n.t('admin.home.index.title'), url: admin_root_path },
        { title: I18n.t('admin.integrations.index.title'), url: admin_integrations_root_path },
        { title: I18n.t('shared.transparency.server_salaries.index.title'), url: admin_integrations_server_salaries_path },
        { title: server_salary.title, url: '' }
      ]

      expect(controller.breadcrumbs).to eq(expected)
    end
  end
end
