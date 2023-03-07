require 'rails_helper'

describe Transparency::Expenses::DailiesController do

  let(:daily) { create(:integration_expenses_daily) }

  context 'index' do
    before { get(:index) }

    it 'breadcrumbs' do
      expected = [
        { title: I18n.t('transparency.home.index.title'), url: transparency_root_path },
        { title: I18n.t('transparency.expenses.dailies.index.title'), url: '' }
      ]

      expect(controller.breadcrumbs).to eq(expected)
    end
  end

  context 'show' do
    before { get(:show, params: { id: daily }) }

    it 'breadcrumbs' do
      expected = [
        { title: I18n.t('transparency.home.index.title'), url: transparency_root_path },
        { title: I18n.t('transparency.expenses.dailies.index.title'), url: transparency_expenses_dailies_path },
        { title: daily.title, url: '' }
      ]

      expect(controller.breadcrumbs).to eq(expected)
    end
  end
end
