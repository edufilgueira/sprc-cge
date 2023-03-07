require 'rails_helper'

describe Transparency::CityUndertakingsController do

  let(:contract) { create(:integration_contracts_contract) }
  let(:city_undertaking) { create(:integration_city_undertakings_city_undertaking, sic: contract.isn_sic) }

  context 'index' do
    before { get(:index) }

    it 'breadcrumbs' do
      expected = [
        { title: I18n.t('transparency.home.index.title'), url: transparency_root_path },
        { title: I18n.t('shared.transparency.city_undertakings.index.title'), url: '' }
      ]

      expect(controller.breadcrumbs).to eq(expected)
    end
  end

  context 'show' do
    before { get(:show, params: { id: city_undertaking }) }

    it 'breadcrumbs' do
      expected = [
        { title: I18n.t('transparency.home.index.title'), url: transparency_root_path },
        { title: I18n.t('shared.transparency.city_undertakings.index.title'), url: transparency_city_undertakings_path },
        { title: city_undertaking.title, url: '' }
      ]

      expect(controller.breadcrumbs).to eq(expected)
    end
  end
end

