require 'rails_helper'

describe Transparency::Expenses::NedsController do

  let(:ned) { create(:integration_expenses_ned) }

  context 'index' do
    before { get(:index) }

    it 'breadcrumbs' do
      expected = [
        { title: I18n.t('transparency.home.index.title'), url: transparency_root_path },
        { title: I18n.t('transparency.expenses.neds.index.title'), url: '' }
      ]

      expect(controller.breadcrumbs).to eq(expected)
    end
  end

  context 'show' do
    before { get(:show, params: { id: ned }) }

    it 'breadcrumbs' do
      expected = [
        { title: I18n.t('transparency.home.index.title'), url: transparency_root_path },
        { title: I18n.t('transparency.expenses.neds.index.title'), url: transparency_expenses_neds_path },
        { title: ned.title, url: '' }
      ]

      expect(controller.breadcrumbs).to eq(expected)
    end
  end
end
