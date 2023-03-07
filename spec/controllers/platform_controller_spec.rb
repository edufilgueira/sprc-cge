require 'rails_helper'

describe PlatformController do

  controller(PlatformController) do
    def index
      render body: ''
    end
  end

  let(:user) { create(:user) }

  context 'non authenticated' do
    before { get(:index) }

    it { is_expected.to redirect_to(new_user_session_path) }
  end

  context 'authenticated' do
    before { sign_in(user) && get(:index) }

    it { is_expected.to respond_with(:success) }

    context 'not user' do
      let(:user) { create(:user, :operator) }

      it { is_expected.to redirect_to(new_user_session_path) }
    end
  end

end
