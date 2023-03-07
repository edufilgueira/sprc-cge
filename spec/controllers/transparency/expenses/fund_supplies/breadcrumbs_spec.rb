require 'rails_helper'

describe Transparency::Expenses::FundSuppliesController do

  let(:fund_supply) { create(:integration_expenses_fund_supply) }

  context 'index' do
    before { get(:index) }

    it 'breadcrumbs' do
      expected = [
        { title: I18n.t('transparency.home.index.title'), url: transparency_root_path },
        { title: I18n.t('transparency.expenses.fund_supplies.index.title'), url: '' }
      ]

      expect(controller.breadcrumbs).to eq(expected)
    end
  end

  context 'show' do
    before { get(:show, params: { id: fund_supply }) }

    it 'breadcrumbs' do
      expected = [
        { title: I18n.t('transparency.home.index.title'), url: transparency_root_path },
        { title: I18n.t('transparency.expenses.fund_supplies.index.title'), url: transparency_expenses_fund_supplies_path },
        { title: fund_supply.title, url: '' }
      ]

      expect(controller.breadcrumbs).to eq(expected)
    end
  end
end
