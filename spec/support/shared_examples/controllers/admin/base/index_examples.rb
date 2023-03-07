# Shared example para action index de base controllers em admin

shared_examples_for 'controllers/admin/base/index' do
  describe '#index' do
    context 'unauthorized' do
      before { get(:index) }

      it { is_expected.to redirect_to(new_user_session_path) }
    end

    context 'admin disabled' do
      before do
        other_user = create(:user, disabled_at: DateTime.now)
        sign_in(other_user) && get(:index)
      end

      it { is_expected.to redirect_to(new_user_session_path) }
    end

    context 'authorized' do
      before { sign_in(user) }

      it_behaves_like 'controllers/base/index'
    end
  end
end
