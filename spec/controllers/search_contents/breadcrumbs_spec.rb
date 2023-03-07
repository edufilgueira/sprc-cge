require 'rails_helper'

describe SearchContentsController do

  let(:search_content) { create(:search_content) }

  context 'index' do
    before { get(:index) }

    it 'breadcrumbs' do
      expected = [
        { title: I18n.t('home.index.title'), url: root_path },
        { title: I18n.t('search_contents.index.title'), url: '' }
      ]

      expect(controller.breadcrumbs).to eq(expected)
    end
  end
end
