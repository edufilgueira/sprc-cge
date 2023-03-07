require 'rails_helper'

describe Transparency::Expenses::NldsController do

  let(:nld) { create(:integration_expenses_nld) }

  context 'index' do
    before { get(:index) }

    it 'breadcrumbs' do
      expected = [
        { title: I18n.t('transparency.home.index.title'), url: transparency_root_path },
        { title: I18n.t('transparency.expenses.nlds.index.title'), url: '' }
      ]

      expect(controller.breadcrumbs).to eq(expected)
    end
  end

  context 'show' do
    before { get(:show, params: { id: nld }) }

    it 'breadcrumbs' do
      expected = [
        { title: I18n.t('transparency.home.index.title'), url: transparency_root_path },
        { title: I18n.t('transparency.expenses.nlds.index.title'), url: transparency_expenses_nlds_path },
        { title: nld.title, url: '' }
      ]

      expect(controller.breadcrumbs).to eq(expected)
    end
  end
end
