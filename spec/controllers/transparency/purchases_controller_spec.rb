require 'rails_helper'

describe Transparency::PurchasesController do
  describe '#index' do
    it_behaves_like 'controllers/transparency/purchases/index'
  end

  describe '#show' do
    it_behaves_like 'controllers/transparency/purchases/show'
  end
end
