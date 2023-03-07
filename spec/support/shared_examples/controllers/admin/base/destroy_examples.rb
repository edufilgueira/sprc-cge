# Shared example para action destroy de base controllers em admin

shared_examples_for 'controllers/admin/base/destroy' do
  describe '#destroy' do
    context 'unauthorized' do
      before { delete(:destroy, params: { id: 1 }) }

      it { is_expected.to redirect_to(new_user_session_path) }
    end

    context 'authorized' do
      before { sign_in(user) }

      it_behaves_like 'controllers/base/destroy'
    end
  end
end
