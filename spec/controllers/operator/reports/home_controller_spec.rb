require 'rails_helper'

describe Operator::Reports::HomeController do

  let(:user) { create(:user, :operator) }

  describe '#index' do
    context 'unauthorized' do
      before { get(:index) }

      it { is_expected.to redirect_to(new_user_session_path) }
    end

    context 'authorized' do
      context 'template' do
        before { sign_in(user) && get(:index) }
        render_views

        it { is_expected.to respond_with(:success) }
        it { is_expected.to render_template(:index) }
      end
    end
  end
end
