require 'rails_helper'

describe Transparency::Results::StrategicIndicatorsController do
  let(:strategic_indicator) { create(:integration_results_strategic_indicator) }

  context 'index' do
    before { get(:index) }

    it 'breadcrumbs' do
      expected = [
        { title: I18n.t('transparency.home.index.title'), url: transparency_root_path },
        { title: I18n.t('transparency.results.strategic_indicators.index.title'), url: '' }
      ]

      expect(controller.breadcrumbs).to eq(expected)
    end
  end

  context 'show' do
    before { get(:show, params: { id: strategic_indicator }) }

    it 'breadcrumbs' do
      expected = [
        { title: I18n.t('transparency.home.index.title'), url: transparency_root_path },
        { title: I18n.t('transparency.results.strategic_indicators.index.title'), url: transparency_results_strategic_indicators_path },
        { title: strategic_indicator.title, url: '' }
      ]

      expect(controller.breadcrumbs).to eq(expected)
    end
  end
end
