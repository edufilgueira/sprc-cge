require 'rails_helper'

describe Transparency::HomeController do
  context 'index' do
    before { get(:index) }

    it 'breadcrumbs' do
      expected = [
        { title: I18n.t('app.home'), url: root_path },
        { title: I18n.t('transparency.home.index.title'), url: '' }
      ]

      expect(controller.breadcrumbs).to eq(expected)
    end
  end
end
