require 'rails_helper'

describe Admin::Integrations::Contracts::ConvenantsController do

  let(:user) { create(:user, :admin) }

  describe '#index' do
    context 'unauthorized' do
      before { get(:index) }

      it { is_expected.to redirect_to(new_user_session_path) }
    end

    context 'authorized' do
      before { sign_in(user) }

      it_behaves_like 'controllers/transparency/contracts/convenants/index'
    end
  end

  describe '#show' do
    context 'unauthorized' do
      before { get(:show, params: { id: 1 }) }

      it { is_expected.to redirect_to(new_user_session_path) }
    end

    context 'authorized' do
      before { sign_in(user) }

      it_behaves_like 'controllers/transparency/contracts/convenants/show'
    end
  end
end
