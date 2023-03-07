require 'rails_helper'

describe Transparency::Expenses::NpdsController do

  let(:npd) { create(:integration_expenses_npd) }

  context 'index' do
    before { get(:index) }

    it 'breadcrumbs' do
      expected = [
        { title: I18n.t('transparency.home.index.title'), url: transparency_root_path },
        { title: I18n.t('transparency.expenses.npds.index.title'), url: '' }
      ]

      expect(controller.breadcrumbs).to eq(expected)
    end
  end

  context 'show' do
    before { get(:show, params: { id: npd }) }

    it 'breadcrumbs' do
      expected = [
        { title: I18n.t('transparency.home.index.title'), url: transparency_root_path },
        { title: I18n.t('transparency.expenses.npds.index.title'), url: transparency_expenses_npds_path },
        { title: npd.title, url: '' }
      ]

      expect(controller.breadcrumbs).to eq(expected)
    end
  end
end
