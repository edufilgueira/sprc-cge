# Shared example para action new de base controllers em ppa/admin
#
# @param admin [PPA::Administrator] to be signed_in with devise
# @param request_params [Hash] any param to be passed to the request

shared_examples_for 'controllers/ppa/admin/base/new' do
  describe '#new' do
    context 'unauthorized' do
      before { send_new_request }

      it { is_expected.to redirect_to(new_ppa_admin_session_path) }
    end

    context 'authorized' do
      before { sign_in(admin) }

      it_behaves_like 'controllers/base/new'
    end
  end

  private

  def send_new_request
    if respond_to?(:request_params)
      get :new, params: request_params
    else
      get :new
    end
  end
end
