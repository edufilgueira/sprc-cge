require 'rails_helper'
# Comentando os testes pois por enquanto o ano está fixado para 2018
# Deve ser removido, após exister NEDs de 2019
describe Transparency::Expenses::NedsController do


  before { create(:stats_expenses_ned, month: 0, month_start: 1, month_end: 1)}

  describe '#index' do
    it_behaves_like 'controllers/transparency/expenses/neds/index'
  end

  describe '#show' do
    it_behaves_like 'controllers/transparency/expenses/neds/show'

    it 'print' do
      get(:show, params: { id: 1, print: true })

      is_expected.to render_template('shared/transparency/expenses/neds/print')
    end
  end
end
