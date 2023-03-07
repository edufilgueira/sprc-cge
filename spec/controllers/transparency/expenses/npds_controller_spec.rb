require 'rails_helper'

describe Transparency::Expenses::NpdsController do
  describe '#index' do
    it_behaves_like 'controllers/transparency/expenses/npds/index'
  end

  describe '#show' do
    it_behaves_like 'controllers/transparency/expenses/npds/show'
  end
end
