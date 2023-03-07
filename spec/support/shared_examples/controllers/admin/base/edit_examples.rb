# Shared example para action edit de base controllers em admin

shared_examples_for 'controllers/admin/base/edit' do
  describe '#edit' do
    context 'unauthorized' do
      before { get(:edit, params: { id: 1 }) }

      it { is_expected.to redirect_to(new_user_session_path) }
    end

    context 'authorized' do
      before { sign_in(user) }

      it_behaves_like 'controllers/base/edit'
    end
  end
end
