require 'rails_helper'

describe Transparency::Expenses::CityTransfersController do

  let(:city_transfer) { create(:integration_expenses_city_transfer) }

  context 'index' do
    before { get(:index) }

    it 'breadcrumbs' do
      expected = [
        { title: I18n.t('transparency.home.index.title'), url: transparency_root_path },
        { title: I18n.t('transparency.expenses.city_transfers.index.title'), url: '' }
      ]

      expect(controller.breadcrumbs).to eq(expected)
    end
  end

  context 'show' do
    before { get(:show, params: { id: city_transfer }) }

    it 'breadcrumbs' do
      expected = [
        { title: I18n.t('transparency.home.index.title'), url: transparency_root_path },
        { title: I18n.t('transparency.expenses.city_transfers.index.title'), url: transparency_expenses_city_transfers_path },
        { title: city_transfer.title, url: '' }
      ]

      expect(controller.breadcrumbs).to eq(expected)
    end
  end
end
