require 'rails_helper'

describe Transparency::Contracts::ConvenantsController do
  describe '#index' do
    it_behaves_like 'controllers/transparency/contracts/convenants/index'
  end

  describe '#show' do
    it_behaves_like 'controllers/transparency/contracts/convenants/show'
  end

  describe 'show_by_instrument' do
    render_views
    let(:convenant) { create(:integration_contracts_convenant) }
    it  do
      convenant.update(isn_sic: 1000)
      get(:show_by_instrument, params: { instrument: 1000})
      expect(controller.convenant).to eq(convenant)
    end
 end
end
