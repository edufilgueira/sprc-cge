# Shared example para action destroy de base controllers em operator

shared_examples_for 'controllers/operator/base/destroy' do
  describe '#destroy' do
    context 'unauthorized' do
      before { delete(:destroy, params: { id: 1 }) }

      it { is_expected.to redirect_to(new_user_session_path) }
    end

    context 'authorized' do
      before { sign_in(user) }

      it_behaves_like 'controllers/base/destroy'
    end

    context 'disabled' do
      before do
        user.disabled_at = DateTime.now
        user.save

        sign_in(user) && delete(:destroy, params: { id: 1 })
      end

      it { is_expected.to redirect_to(new_user_session_path) }
    end
  end
end
