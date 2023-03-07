require 'rails_helper'

describe Admin::Integrations::Results::ThematicIndicatorsController do
  let(:user) { create(:user, :admin) }
  let(:indicator) { create(:integration_results_thematic_indicator) }


  context 'index' do
    before { sign_in(user) && get(:index) }

    it 'breadcrumbs' do
      expected = [
        { title: I18n.t('admin.home.index.title'), url: admin_root_path },
        { title: I18n.t('admin.integrations.index.title'), url: admin_integrations_root_path },
        { title: I18n.t('admin.integrations.results.index.title'), url: admin_integrations_results_root_path },
        { title: I18n.t('admin.integrations.results.thematic_indicators.index.title'), url: '' }
      ]

      expect(controller.breadcrumbs).to eq(expected)
    end
  end

  context 'show' do
    before { sign_in(user) && get(:show, params: { id: indicator }) }

    it 'breadcrumbs' do
      expected = [
        { title: I18n.t('admin.home.index.title'), url: admin_root_path },
        { title: I18n.t('admin.integrations.index.title'), url: admin_integrations_root_path },
        { title: I18n.t('admin.integrations.results.index.title'), url: admin_integrations_results_root_path },
        { title: I18n.t('admin.integrations.results.thematic_indicators.index.title'), url: admin_integrations_results_thematic_indicators_path },
        { title: indicator.title, url: '' }
      ]

      expect(controller.breadcrumbs).to eq(expected)
    end
  end
end
