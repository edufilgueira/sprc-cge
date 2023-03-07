require 'rails_helper'

describe Admin::IntegrationsController do

  let(:user) { create(:user, :admin) }

  describe '#index' do
    context 'unauthorized' do
      before { get(:index) }

      it { is_expected.to redirect_to(new_user_session_path) }
    end

    context 'authorized' do
      before { sign_in(user) && get(:index) }

      context 'template' do
        render_views

        it { is_expected.to respond_with(:success) }
      end
    end
  end

end
