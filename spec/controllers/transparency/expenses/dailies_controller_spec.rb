require 'rails_helper'

# Comentando os testes pois por enquanto o ano está fixado para 2018
# Deve ser removido, após exister NEDs de 2019
describe Transparency::Expenses::DailiesController do
  describe '#index' do
    it_behaves_like 'controllers/transparency/expenses/dailies/index'
  end

  describe '#show' do
    it_behaves_like 'controllers/transparency/expenses/dailies/show'
  end
end
