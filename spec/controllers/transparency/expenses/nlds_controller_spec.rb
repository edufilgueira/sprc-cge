require 'rails_helper'

describe Transparency::Expenses::NldsController do
  describe '#index' do
    it_behaves_like 'controllers/transparency/expenses/nlds/index'
  end

  describe '#show' do
    it_behaves_like 'controllers/transparency/expenses/nlds/show'
  end
end
