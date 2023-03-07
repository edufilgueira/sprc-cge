require 'rails_helper'

describe Transparency::Expenses::NpfsController do
  describe '#index' do
    it_behaves_like 'controllers/transparency/expenses/npfs/index'
  end

  describe '#show' do
    it_behaves_like 'controllers/transparency/expenses/npfs/show'
  end
end
