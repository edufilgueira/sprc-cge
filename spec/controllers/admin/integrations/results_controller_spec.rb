require 'rails_helper'

describe Admin::Integrations::ResultsController do

  let(:user) { create(:user, :admin) }

  describe '#index' do
    context 'unauthorized' do
      before { get(:index) }

      it { is_expected.to redirect_to(new_user_session_path) }
    end

    context 'authorized' do
      before { sign_in(user) && get(:index) }

      it { is_expected.to respond_with(:success) }
      it { is_expected.to render_template('results/index') }
    end
  end
end
