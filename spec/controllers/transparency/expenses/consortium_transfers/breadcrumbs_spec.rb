require 'rails_helper'

describe Transparency::Expenses::ConsortiumTransfersController do

  let(:consortium_transfer) { create(:integration_expenses_consortium_transfer) }

  context 'index' do
    before { get(:index) }

    it 'breadcrumbs' do
      expected = [
        { title: I18n.t('transparency.home.index.title'), url: transparency_root_path },
        { title: I18n.t('transparency.expenses.consortium_transfers.index.title'), url: '' }
      ]

      expect(controller.breadcrumbs).to eq(expected)
    end
  end

  context 'show' do
    before { get(:show, params: { id: consortium_transfer }) }

    it 'breadcrumbs' do
      expected = [
        { title: I18n.t('transparency.home.index.title'), url: transparency_root_path },
        { title: I18n.t('transparency.expenses.consortium_transfers.index.title'), url: transparency_expenses_consortium_transfers_path },
        { title: consortium_transfer.title, url: '' }
      ]

      expect(controller.breadcrumbs).to eq(expected)
    end
  end
end
