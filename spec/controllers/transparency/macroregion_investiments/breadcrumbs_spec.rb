require 'rails_helper'

describe Transparency::MacroregionInvestimentsController do

  let(:investment) { create(:integration_macroregions_macroregion_investiment) }

  context 'index' do
    before { get(:index) }

    it 'breadcrumbs' do
      expected = [
        { title: I18n.t('transparency.home.index.title'), url: transparency_root_path },
        { title: I18n.t('shared.transparency.macroregion_investiments.index.title'), url: '' }
      ]

      expect(controller.breadcrumbs).to eq(expected)
    end
  end
end

