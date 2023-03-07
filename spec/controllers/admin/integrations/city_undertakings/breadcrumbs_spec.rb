require 'rails_helper'

describe Admin::Integrations::CityUndertakingsController do

  let(:user) { create(:user, :admin) }
  let(:contract) { create(:integration_contracts_contract) }
  let(:city_undertaking) { create(:integration_city_undertakings_city_undertaking, sic: contract.isn_sic) }

  context 'index' do
    before { sign_in(user) && get(:index) }

    it 'breadcrumbs' do
      expected = [
        { title: I18n.t('admin.home.index.title'), url: admin_root_path },
        { title: I18n.t('admin.integrations.index.title'), url: admin_integrations_root_path },
        { title: I18n.t('shared.transparency.city_undertakings.index.title'), url: '' }
      ]

      expect(controller.breadcrumbs).to eq(expected)
    end
  end

  context 'show' do
    before { sign_in(user) && get(:show, params: { id: city_undertaking }) }

    it 'breadcrumbs' do
      expected = [
        { title: I18n.t('admin.home.index.title'), url: admin_root_path },
        { title: I18n.t('admin.integrations.index.title'), url: admin_integrations_root_path },
        { title: I18n.t('shared.transparency.city_undertakings.index.title'), url: admin_integrations_city_undertakings_path },
        { title: city_undertaking.title, url: '' }
      ]

      expect(controller.breadcrumbs).to eq(expected)
    end
  end
end
