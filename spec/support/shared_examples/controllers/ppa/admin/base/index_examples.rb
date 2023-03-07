# Shared example para action index de base controllers em ppa/admin
#
# @param admin [PPA::Administrator] to be signed_in with devise
# @param resources [Array] an array of resources for controller
# @param request_params [Hash] any param to be passed to the request

shared_examples_for 'controllers/ppa/admin/base/index' do
  describe '#index' do
    context 'unauthorized' do
      before { send_index_request }

      it { is_expected.to redirect_to(new_ppa_admin_session_path) }
    end

    context 'authorized' do
      before do
        sign_in(admin)
        send_index_request
      end

      context 'template' do
        render_views


        it 'responds with success' do
          expect(response).to be_success
        end

        it 'renders templates' do
          expect(response).to render_template("#{controller.controller_path}/index")
        end

        it { is_expected.to render_template('layouts/ppa/admin') }
      end

      describe 'helper methods' do
        it 'resources' do
          expect(controller.send(resources_symbol)).to eq(resources)
        end
      end
    end
  end

  private

  def send_index_request
    if respond_to?(:request_params)
      get :index, params: request_params
    else
      get :index
    end
  end

  def resource_name
    controller.controller_name.singularize
  end

  def resources_symbol
    (controller.try(:send, :resource_symbol) || resource_name).to_s.pluralize.to_sym
  end
end
