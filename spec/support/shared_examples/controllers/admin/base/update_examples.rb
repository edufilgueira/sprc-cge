# Shared example para action update de base controllers em admin

shared_examples_for 'controllers/admin/base/update' do
  describe '#update' do
    context 'unauthorized' do
      before { patch(:update, params: { id: 1 }) }

      it { is_expected.to redirect_to(new_user_session_path) }
    end

    context 'authorized' do
      before { sign_in(user) }

      it_behaves_like 'controllers/base/update'
    end
  end
end
