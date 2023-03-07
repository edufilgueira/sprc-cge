require 'rails_helper'

# Comentando os testes pois por enquanto o ano está fixado para 2018
# Deve ser removido, após exister NEDs de 2019
describe Admin::Integrations::Expenses::BudgetBalancesController do

  let(:user) { create(:user, :admin) }

  describe '#index' do
    context 'unauthorized' do
      before { get(:index) }

      it { is_expected.to redirect_to(new_user_session_path) }
    end

    context 'authorized' do
      before { sign_in(user) }

      it_behaves_like 'controllers/transparency/expenses/budget_balances/index'
    end
  end
end
