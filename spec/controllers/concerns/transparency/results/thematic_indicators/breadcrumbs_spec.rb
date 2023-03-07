require 'rails_helper'

describe Transparency::Results::ThematicIndicatorsController do
  let(:thematic_indicator) { create(:integration_results_thematic_indicator) }

  context 'index' do
    before { get(:index) }

    it 'breadcrumbs' do
      expected = [
        { title: I18n.t('transparency.home.index.title'), url: transparency_root_path },
        { title: I18n.t('transparency.results.thematic_indicators.index.title'), url: '' }
      ]

      expect(controller.breadcrumbs).to eq(expected)
    end
  end

  context 'show' do
    before { get(:show, params: { id: thematic_indicator }) }

    it 'breadcrumbs' do
      expected = [
        { title: I18n.t('transparency.home.index.title'), url: transparency_root_path },
        { title: I18n.t('transparency.results.thematic_indicators.index.title'), url: transparency_results_thematic_indicators_path },
        { title: thematic_indicator.title, url: '' }
      ]

      expect(controller.breadcrumbs).to eq(expected)
    end
  end
end
