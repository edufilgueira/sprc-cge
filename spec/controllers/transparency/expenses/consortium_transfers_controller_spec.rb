require 'rails_helper'

describe Transparency::Expenses::ConsortiumTransfersController do
  describe '#index' do
    it_behaves_like 'controllers/transparency/expenses/consortium_transfers/index'
  end

  describe '#show' do
    it_behaves_like 'controllers/transparency/expenses/consortium_transfers/show'
  end
end
