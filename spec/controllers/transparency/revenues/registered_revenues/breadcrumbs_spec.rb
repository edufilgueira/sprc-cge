require 'rails_helper'

describe Transparency::Revenues::RegisteredRevenuesController do

  context 'index' do
    before { get(:index) }

    it 'breadcrumbs' do
      expected = [
        { title: I18n.t('transparency.home.index.title'), url: transparency_root_path },
        { title: I18n.t('shared.transparency.revenues.registered_revenues.index.title'), url: '' }
      ]

      expect(controller.breadcrumbs).to eq(expected)
    end
  end
end
