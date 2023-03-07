require 'rails_helper'

describe Transparency::Constructions::DaesController do
  let(:dae) { create(:integration_constructions_dae) }

  context 'index' do
    before { get(:index) }

    it 'breadcrumbs' do
      expected = [
        { title: I18n.t('transparency.home.index.title'), url: transparency_root_path },
        { title: I18n.t('shared.transparency.constructions.daes.index.title'), url: '' }
      ]

      expect(controller.breadcrumbs).to eq(expected)
    end
  end

  context 'show' do
    before { get(:show, params: { id: dae }) }

    it 'breadcrumbs' do
      expected = [
        { title: I18n.t('transparency.home.index.title'), url: transparency_root_path },
        { title: I18n.t('shared.transparency.constructions.daes.index.title'), url: transparency_constructions_daes_path },
        { title: dae.title, url: '' }
      ]

      expect(controller.breadcrumbs).to eq(expected)
    end
  end
end
