# Shared example para action new de base controllers em operator

shared_examples_for 'controllers/operator/base/new' do
  describe '#new' do
    context 'unauthorized' do
      before { get(:new) }

      it { is_expected.to redirect_to(new_user_session_path) }
    end

    context 'authorized' do
      before { sign_in(user) }

      it_behaves_like 'controllers/base/new'
    end

    context 'disabled' do
      before do
        user.disabled_at = DateTime.now
        user.save

        sign_in(user) && get(:new)
      end

      it { is_expected.to redirect_to(new_user_session_path) }
    end
  end
end
