# Shared example para action destroy de base controllers em ppa/admin
#
# @param admin [PPA::Administrator] to be signed_in with devise
# @param resources [Array] an array of resources for controller
# @param request_params [Hash] any param to be passed to the request

shared_examples_for 'controllers/ppa/admin/base/destroy' do

  describe '#destroy' do
    let!(:resource) { resources.first }

    context 'unauthorized' do
      before { send_destroy_request }

      it { is_expected.to redirect_to(new_ppa_admin_session_path) }
    end

    context 'authorized' do

      before { sign_in(admin) }

      context 'success deletion' do
        it 'remove from db' do
          expect { send_destroy_request }.to change(resource_model, :count).by(-1)
        end

        context 'flash and redirects' do
          let(:expected_flash) { I18n.t("#{locale_path}.destroy.done") }

          before { send_destroy_request }

          it { expect(controller_resource).to eq(resource) }
          it { expect(response).to redirect_to(controller.send(:resource_index_path)) }
          it { expect(controller).to set_flash.to(expected_flash) }
        end
      end


      context 'failed deletion' do
        let(:expected_flash) { I18n.t("#{locale_path}.destroy.error") }

        before do
          allow_any_instance_of(resource_model).to receive(:destroy).and_return(false)
          send_destroy_request
        end

        it { expect(response).to redirect_to(controller.send(:resource_index_path)) }
        it { expect(controller).to set_flash.to(expected_flash) }
      end
    end
  end

  private

  def send_destroy_request
    if try(:request_params)
      delete(:destroy, params: request_params.merge(id: resource))
    else
      delete(:destroy, params: { id: resource })
    end
  end

  def controller_resource
    controller.send(resource_symbol)
  end

  def resource_name
    controller.controller_name.singularize
  end

  def resource_symbol
    controller.try(:send, :resource_symbol) || resource_name.to_sym
  end

  def locale_path
    view_path.gsub('/', '.')
  end

  def view_path
    controller.controller_path
  end

  def resource_model
    controller.send(:resource_klass)
  end

end
