# Shared example para action index de base controllers em operator

shared_examples_for 'controllers/operator/base/index' do
  describe '#index' do
    context 'unauthorized' do
      before { get(:index) }

      it { is_expected.to redirect_to(new_user_session_path) }
    end

    context 'authorized' do
      before { sign_in(user) }

      it_behaves_like 'controllers/base/index'
    end

    context 'disabled' do
      before do
        user.disabled_at = DateTime.now
        user.save

        sign_in(user) && get(:index)
      end

      it { is_expected.to redirect_to(new_user_session_path) }
    end
  end
end
