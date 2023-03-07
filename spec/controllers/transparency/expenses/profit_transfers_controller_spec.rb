require 'rails_helper'

describe Transparency::Expenses::ProfitTransfersController do
  describe '#index' do
    it_behaves_like 'controllers/transparency/expenses/profit_transfers/index'
  end

  describe '#show' do
    it_behaves_like 'controllers/transparency/expenses/profit_transfers/show'
  end
end
