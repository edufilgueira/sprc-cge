# Shared example para action new de base controllers em admin

shared_examples_for 'controllers/admin/base/new' do
  describe '#new' do
    context 'unauthorized' do
      before { get(:new) }

      it { is_expected.to redirect_to(new_user_session_path) }
    end

    context 'authorized' do
      before { sign_in(user) }

      it_behaves_like 'controllers/base/new'
    end
  end
end
