# Shared example para devise controllers
shared_examples_for 'controllers/base/single_authentication_guard' do

  describe 'when already sign_in' do

    let(:expected_flash) { I18n.t("devise.sessions.already_authenticated") }

    before { sign_in(user) }

    context '#create' do
      let(:permitted_params) do
        { user: attributes_for(:user) }
      end

      before { post(:create, params: permitted_params) }

      context 'as user' do
        let(:user) { create(:user) }

        it { expect(response).to redirect_to(root_path) }
      end

      context 'as ticket_area' do
        let(:user) { create(:ticket) }

        it { expect(response).to redirect_to(root_path) }
      end
    end
  end
end
