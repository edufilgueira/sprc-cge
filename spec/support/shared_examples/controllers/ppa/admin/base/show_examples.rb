# Shared example para action show de base controllers em ppa/admin
#
# @param admin [PPA::Administrator] to be signed_in with devise
# @param resources [Array] an array of resources for controller
# @param request_params [Hash] any param to be passed to the request

shared_examples_for 'controllers/ppa/admin/base/show' do
  describe '#show' do
    context 'unauthorized' do
      let(:resource) { resources.first }

      before { send_show_request }

      it { is_expected.to redirect_to(new_ppa_admin_session_path) }
    end

    context 'authorized' do
      before { sign_in(admin) }

      it_behaves_like 'controllers/base/show'
    end
  end

  private

  def send_show_request
    if respond_to?(:request_params)
      get :show, params: { id: resource }.merge(request_params)
    else
      get :show, params: { id: resource }
    end
  end
end
