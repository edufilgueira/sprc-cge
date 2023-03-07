require 'rails_helper'

describe Transparency::PurchasesController do

  let(:purchase) { create(:integration_purchases_purchase) }

  context 'index' do
    before { get(:index) }

    it 'breadcrumbs' do
      expected = [
        { title: I18n.t('transparency.home.index.title'), url: transparency_root_path },
        { title: I18n.t('shared.transparency.purchases.index.title'), url: '' }
      ]

      expect(controller.breadcrumbs).to eq(expected)
    end
  end

  context 'show' do
    before { get(:show, params: { id: purchase }) }

    it 'breadcrumbs' do
      expected = [
        { title: I18n.t('transparency.home.index.title'), url: transparency_root_path },
        { title: I18n.t('shared.transparency.purchases.index.title'), url: transparency_purchases_path },
        { title: purchase.title, url: '' }
      ]

      expect(controller.breadcrumbs).to eq(expected)
    end
  end
end

