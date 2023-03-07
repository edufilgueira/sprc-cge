# Shared example para action show de base controllers em admin

shared_examples_for 'controllers/admin/base/show' do
  describe '#show' do
    context 'unauthorized' do
      let(:resource) { resources.first }

      before { get(:show, params: { id: resource }) }

      it { is_expected.to redirect_to(new_user_session_path) }
    end

    context 'authorized' do
      before { sign_in(user) }

      it_behaves_like 'controllers/base/show'
    end
  end
end
