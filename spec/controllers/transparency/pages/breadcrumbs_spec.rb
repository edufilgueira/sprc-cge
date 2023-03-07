require 'rails_helper'

describe Transparency::PagesController do
  let(:page) { create(:page) }

  context 'index' do
    before { get(:index) }

    it 'breadcrumbs' do
      expected = [
        { title: I18n.t('app.home'), url: root_path },
        { title: I18n.t('transparency.home.index.title'), url: transparency_root_path },
        { title: I18n.t('transparency.pages.index.title'), url: '' }
      ]

      expect(controller.breadcrumbs).to eq(expected)
    end
  end

  context 'show' do
    before { get(:show, params: { id: page }) }

    it 'breadcrumbs' do
      expected = [
        { title: I18n.t('app.home'), url: root_path },
        { title: I18n.t('transparency.home.index.title'), url: transparency_root_path },
        { title: page.title, url: '' }
      ]

      expect(controller.breadcrumbs).to eq(expected)
    end
  end
end
