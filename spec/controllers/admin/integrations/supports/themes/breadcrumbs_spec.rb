require 'rails_helper'

describe Admin::Integrations::Supports::ThemesController do
  let(:user) { create(:user, :admin) }
  let(:theme) { create(:integration_supports_theme) }

  context 'index' do
    before { sign_in(user) && get(:index) }

    it 'breadcrumbs' do
      expected = [
        { title: I18n.t('admin.home.index.title'), url: admin_root_path },
        { title: I18n.t('admin.integrations.index.title'), url: admin_integrations_root_path },
        { title: I18n.t('admin.integrations.supports.themes.index.title'), url: '' }
      ]

      expect(controller.breadcrumbs).to eq(expected)
    end
  end

  context 'show' do
    before { sign_in(user) && get(:show, params: { id: theme }) }

    it 'breadcrumbs' do
      expected = [
        { title: I18n.t('admin.home.index.title'), url: admin_root_path },
        { title: I18n.t('admin.integrations.index.title'), url: admin_integrations_root_path },
        { title: I18n.t('admin.integrations.supports.themes.index.title'), url: admin_integrations_supports_themes_path },
        { title: theme.title.truncate(20), url: '' }
      ]

      expect(controller.breadcrumbs).to eq(expected)
    end
  end
end
