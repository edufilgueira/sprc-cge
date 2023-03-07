require 'rails_helper'

describe Transparency::Revenues::AccountsController do

  let(:revenue) { create(:integration_revenues_revenue) }

  context 'index' do
    before { get(:index) }

    it 'breadcrumbs' do
      expected = [
        { title: I18n.t('transparency.home.index.title'), url: transparency_root_path },
        { title: I18n.t('shared.transparency.revenues.accounts.index.title'), url: '' }
      ]

      expect(controller.breadcrumbs).to eq(expected)
    end
  end
end
