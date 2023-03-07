require 'rails_helper'

describe Transparency::ServerSalariesController do

  let(:server_salary) { create(:integration_servers_server_salary) }

  context 'index' do
    before { get(:index) }

    it 'breadcrumbs' do
      expected = [
        { title: I18n.t('transparency.home.index.title'), url: transparency_root_path },
        { title: I18n.t('shared.transparency.server_salaries.index.title'), url: '' }
      ]

      expect(controller.breadcrumbs).to eq(expected)
    end
  end

  context 'show' do
    before { get(:show, params: { id: server_salary }) }

    it 'breadcrumbs' do
      expected = [
        { title: I18n.t('transparency.home.index.title'), url: transparency_root_path },
        { title: I18n.t('shared.transparency.server_salaries.index.title'), url: transparency_server_salaries_path },
        { title: server_salary.title, url: '' }
      ]

      expect(controller.breadcrumbs).to eq(expected)
    end
  end
end
