require 'rails_helper'

describe Transparency::Expenses::NonProfitTransfersController do
  describe '#index' do
    it_behaves_like 'controllers/transparency/expenses/non_profit_transfers/index'
  end

  describe '#show' do
    it_behaves_like 'controllers/transparency/expenses/non_profit_transfers/show'
  end
end
