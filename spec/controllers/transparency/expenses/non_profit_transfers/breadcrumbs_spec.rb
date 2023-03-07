require 'rails_helper'

describe Transparency::Expenses::NonProfitTransfersController do

  let(:non_profit_transfer) { create(:integration_expenses_non_profit_transfer) }

  context 'index' do
    before { get(:index) }

    it 'breadcrumbs' do
      expected = [
        { title: I18n.t('transparency.home.index.title'), url: transparency_root_path },
        { title: I18n.t('transparency.expenses.non_profit_transfers.index.title'), url: '' }
      ]

      expect(controller.breadcrumbs).to eq(expected)
    end
  end

  context 'show' do
    before { get(:show, params: { id: non_profit_transfer }) }

    it 'breadcrumbs' do
      expected = [
        { title: I18n.t('transparency.home.index.title'), url: transparency_root_path },
        { title: I18n.t('transparency.expenses.non_profit_transfers.index.title'), url: transparency_expenses_non_profit_transfers_path },
        { title: non_profit_transfer.title, url: '' }
      ]

      expect(controller.breadcrumbs).to eq(expected)
    end
  end
end
