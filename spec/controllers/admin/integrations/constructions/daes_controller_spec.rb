require 'rails_helper'

describe Admin::Integrations::Constructions::DaesController do

  let(:user) { create(:user, :admin) }

  describe '#index' do
    context 'unauthorized' do
      before { get(:index) }

      it { is_expected.to redirect_to(new_user_session_path) }
    end

    context 'authorized' do
      before { sign_in(user) }

      it_behaves_like 'controllers/transparency/constructions/daes/index'
    end
  end

  describe '#show' do
    context 'unauthorized' do
      before { get(:show, params: { id: 1 }) }

      it { is_expected.to redirect_to(new_user_session_path) }
    end

    context 'authorized' do
      let(:dae) { create(:integration_constructions_dae) }
      let(:url) { admin_integrations_constructions_dae_url(dae) }

      before { sign_in(user) }

      it_behaves_like 'controllers/transparency/constructions/daes/show'
    end
  end

end
