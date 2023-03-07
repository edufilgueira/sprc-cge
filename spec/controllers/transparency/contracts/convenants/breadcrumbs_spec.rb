require 'rails_helper'

describe Transparency::Contracts::ConvenantsController do

  let(:convenant) { create(:integration_contracts_convenant) }

  context 'index' do
    before { get(:index) }

    it 'breadcrumbs' do
      expected = [
        { title: I18n.t('transparency.home.index.title'), url: transparency_root_path },
        { title: I18n.t('shared.transparency.contracts.convenants.index.title'), url: '' }
      ]

      expect(controller.breadcrumbs).to eq(expected)
    end
  end

  context 'show' do
    before { get(:show, params: { id: convenant }) }

    it 'breadcrumbs' do
      expected = [
        { title: I18n.t('transparency.home.index.title'), url: transparency_root_path },
        { title: I18n.t('shared.transparency.contracts.convenants.index.title'), url: transparency_contracts_convenants_path },
        { title: convenant.title, url: '' }
      ]

      expect(controller.breadcrumbs).to eq(expected)
    end
  end
end
