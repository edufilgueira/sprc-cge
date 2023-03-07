require 'rails_helper'

describe Transparency::Expenses::MultiGovTransfersController do

  let(:multi_gov_transfer) { create(:integration_expenses_multi_gov_transfer) }

  context 'index' do
    before { get(:index) }

    it 'breadcrumbs' do
      expected = [
        { title: I18n.t('transparency.home.index.title'), url: transparency_root_path },
        { title: I18n.t('transparency.expenses.multi_gov_transfers.index.title'), url: '' }
      ]

      expect(controller.breadcrumbs).to eq(expected)
    end
  end

  context 'show' do
    before { get(:show, params: { id: multi_gov_transfer }) }

    it 'breadcrumbs' do
      expected = [
        { title: I18n.t('transparency.home.index.title'), url: transparency_root_path },
        { title: I18n.t('transparency.expenses.multi_gov_transfers.index.title'), url: transparency_expenses_multi_gov_transfers_path },
        { title: multi_gov_transfer.title, url: '' }
      ]

      expect(controller.breadcrumbs).to eq(expected)
    end
  end
end
