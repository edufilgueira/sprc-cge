# Shared example para action update de base controllers em operator

shared_examples_for 'controllers/operator/base/update' do

  let(:resource) { resources.first }

  describe '#update' do
    context 'unauthorized' do
      before { patch(:update, params: valid_params.merge(id: resource.id)) }

      it { is_expected.to redirect_to(new_user_session_path) }
    end

    context 'authorized' do
      before { sign_in(user) }

      it_behaves_like 'controllers/base/update'
    end

    context 'disabled' do
      before do
        user.disabled_at = DateTime.now
        user.save

        sign_in(user) && patch(:update, params: valid_params.merge(id: resource.id))
      end

      it { is_expected.to redirect_to(new_user_session_path) }
    end
  end
end
