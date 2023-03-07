require 'rails_helper'

describe Transparency::Contracts::ContractsController do
  describe '#index' do
    it_behaves_like 'controllers/transparency/contracts/contracts/index'
  end

  describe '#show' do
    it_behaves_like 'controllers/transparency/contracts/contracts/show'
  end

  describe 'show_by_instrument' do
    render_views
    let(:contract) { create(:integration_contracts_contract) }
    it  do
      contract.update(isn_sic: 1000)
      get(:show_by_instrument, params: { instrument: 1000})
      expect(controller.contract).to eq(contract)
    end
 end
end
