require 'rails_helper'

describe OperatorController do

  controller(OperatorController) do
    def index
      render body: ''
    end
  end

  let(:user) { create(:user, :operator) }

  context 'non authenticated' do
    before { get(:index) }

    it { is_expected.to redirect_to(new_user_session_path) }
  end

  context 'authenticated' do
    before { sign_in(user) && get(:index) }

    it { is_expected.to respond_with(:success) }

    context 'not operator' do
      let(:user) { create(:user) }

      it { is_expected.to redirect_to(new_user_session_path) }
    end
  end

end
