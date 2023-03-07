require 'rails_helper'

describe Transparency::Expenses::MultiGovTransfersController do
  describe '#index' do
    it_behaves_like 'controllers/transparency/expenses/multi_gov_transfers/index'
  end

  describe '#show' do
    it_behaves_like 'controllers/transparency/expenses/multi_gov_transfers/show'
  end
end
