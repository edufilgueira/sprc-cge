require 'rails_helper'

describe Transparency::Constructions::DersController do
  let(:der) { create(:integration_constructions_der) }

  context 'index' do
    before { get(:index) }

    it 'breadcrumbs' do
      expected = [
        { title: I18n.t('transparency.home.index.title'), url: transparency_root_path },
        { title: I18n.t('shared.transparency.constructions.ders.index.title'), url: '' }
      ]

      expect(controller.breadcrumbs).to eq(expected)
    end
  end

  context 'show' do
    before { get(:show, params: { id: der }) }

    it 'breadcrumbs' do
      expected = [
        { title: I18n.t('transparency.home.index.title'), url: transparency_root_path },
        { title: I18n.t('shared.transparency.constructions.ders.index.title'), url: transparency_constructions_ders_path },
        { title: der.title, url: '' }
      ]

      expect(controller.breadcrumbs).to eq(expected)
    end
  end
end
