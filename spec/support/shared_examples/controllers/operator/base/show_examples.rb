# Shared example para action show de base controllers em operator

shared_examples_for 'controllers/operator/base/show' do
  describe '#show' do
    let(:resource) { resources.first }

    context 'unauthorized' do

      before { get(:show, params: { id: resource }) }

      it { is_expected.to redirect_to(new_user_session_path) }
    end

    context 'authorized' do
      before { sign_in(user) }

      it_behaves_like 'controllers/base/show'
    end

    context 'disabled' do
      before do
        user.disabled_at = DateTime.now
        user.save

        sign_in(user) && get(:show, params: { id: resource })
      end

      it { is_expected.to redirect_to(new_user_session_path) }
    end
  end
end
