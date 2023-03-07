require 'rails_helper'

describe Transparency::Expenses::NpfsController do

  let(:npf) { create(:integration_expenses_npf) }

  context 'index' do
    before { get(:index) }

    it 'breadcrumbs' do
      expected = [
        { title: I18n.t('transparency.home.index.title'), url: transparency_root_path },
        { title: I18n.t('transparency.expenses.npfs.index.title'), url: '' }
      ]

      expect(controller.breadcrumbs).to eq(expected)
    end
  end

  context 'show' do
    before { get(:show, params: { id: npf }) }

    it 'breadcrumbs' do
      expected = [
        { title: I18n.t('transparency.home.index.title'), url: transparency_root_path },
        { title: I18n.t('transparency.expenses.npfs.index.title'), url: transparency_expenses_npfs_path },
        { title: npf.title, url: '' }
      ]

      expect(controller.breadcrumbs).to eq(expected)
    end
  end
end
