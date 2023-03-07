require 'rails_helper'

describe Transparency::OpenData::DataSetsController do

  let(:data_set) { create(:data_set) }

  context 'index' do
    before { get(:index) }

    it 'breadcrumbs' do
      expected = [
        { title: I18n.t('transparency.home.index.title'), url: transparency_root_path },
        { title: I18n.t('transparency.open_data.data_sets.index.title'), url: '' }
      ]

      expect(controller.breadcrumbs).to eq(expected)
    end
  end

  context 'show' do
    before { get(:show, params: { id: data_set }) }

    it 'breadcrumbs' do
      expected = [
        { title: I18n.t('transparency.home.index.title'), url: transparency_root_path },
        { title: I18n.t('transparency.open_data.data_sets.index.title'), url: transparency_open_data_data_sets_path },
        { title: data_set.title, url: '' }
      ]

      expect(controller.breadcrumbs).to eq(expected)
    end
  end
end
