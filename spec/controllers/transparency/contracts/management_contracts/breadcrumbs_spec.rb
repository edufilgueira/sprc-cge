require 'rails_helper'

describe Transparency::Contracts::ManagementContractsController do
  let(:contract) { create(:integration_contracts_contract, :management) }

  context 'index' do
    before { get(:index) }

    it 'breadcrumbs' do
      expected = [
        { title: I18n.t('transparency.home.index.title'), url: transparency_root_path },
        { title: I18n.t('shared.transparency.contracts.management_contracts.index.title'), url: '' }
      ]

      expect(controller.breadcrumbs).to eq(expected)
    end
  end

  context 'show' do
    before { get(:show, params: { id: contract }) }

    it 'breadcrumbs' do
      expected = [
        { title: I18n.t('transparency.home.index.title'), url: transparency_root_path },
        { title: I18n.t('shared.transparency.contracts.management_contracts.index.title'), url: transparency_contracts_management_contracts_path },
        { title: contract.title, url: '' }
      ]

      expect(controller.breadcrumbs).to eq(expected)
    end
  end
end
