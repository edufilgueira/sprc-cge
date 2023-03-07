# Shared example para action edit de base controllers em ppa/admin
#
# @param admin [PPA::Administrator] to be signed_in with devise
# @param resources [Array] an array of resources for controller
# @param request_params [Hash] any param to be passed to the request

shared_examples_for 'controllers/ppa/admin/base/edit' do
  describe '#edit' do
    let(:resource) { resources.first }

    context 'unauthorized' do
      before { send_edit_request }

      it { is_expected.to redirect_to(new_ppa_admin_session_path) }
    end

    context 'authorized' do
      before do
        sign_in(admin)
        send_edit_request
      end

      context 'template' do
        render_views

        it 'responds with success and renders templates' do
          expect(response).to be_success
          expect(response).to render_template("#{controller.controller_path}/edit")
          expect(response).to render_template("#{controller.controller_path}/_form")
        end
      end

      context 'assets' do
        # helpers de javascript/stylesheets por asset
        it_behaves_like 'controllers/base/assets'
      end

      it 'resource instance' do
        expect(controller.send(resource_symbol)).to eq(resource)
      end
    end
  end

  private

  def resource_name
    controller.controller_name.singularize
  end

  def resource_symbol
    controller.try(:send, :resource_symbol) || resource_name.to_sym
  end

  def send_edit_request
    if respond_to?(:request_params)
      get :edit, params: { id: resource }.merge(request_params)
    else
      get :edit, params: { id: resource }
    end
  end
end
