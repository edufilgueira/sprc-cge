require 'rails_helper'

describe Transparency::Expenses::CityTransfersController do
  describe '#index' do
    it_behaves_like 'controllers/transparency/expenses/city_transfers/index'
  end

  describe '#show' do
    it_behaves_like 'controllers/transparency/expenses/city_transfers/show'
  end
end
