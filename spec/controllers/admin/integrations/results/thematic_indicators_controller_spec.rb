require 'rails_helper'

describe Admin::Integrations::Results::ThematicIndicatorsController do

  let(:user) { create(:user, :admin) }

  describe '#index' do
    context 'unauthorized' do
      before { get(:index) }

      it { is_expected.to redirect_to(new_user_session_path) }
    end

    context 'authorized' do
      before { sign_in(user) }

      it_behaves_like 'controllers/transparency/results/thematic_indicators/index'
    end
  end

  describe '#show' do
    context 'unauthorized' do
      before { get(:show, params: { id: 1 }) }

      it { is_expected.to redirect_to(new_user_session_path) }
    end

    context 'authorized' do
      before { sign_in(user) }

      it_behaves_like 'controllers/transparency/results/thematic_indicators/show'
    end
  end

end
