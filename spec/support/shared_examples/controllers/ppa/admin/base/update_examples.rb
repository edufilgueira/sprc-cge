# Shared example para action update de base controllers em ppa/admin
#
# @param admin [PPA::Administrator] to be signed_in with devise
# @param resources [Array] an array of resources for controller
# @param request_params [Hash] any param to be passed to the request

shared_examples_for 'controllers/ppa/admin/base/update' do
  describe '#update' do
    context 'unauthorized' do
      let(:resource) { resources.first }

      before { send_update_request }

      it { is_expected.to redirect_to(new_ppa_admin_session_path) }
    end

    context 'authorized' do
      before { sign_in admin }

      let(:resource) { resources.first }

      context 'valid' do
        before { send_update_request }

        it { expect(response).to redirect_to(controller.send(:resource_show_path)) }
        it { expect(controller).to set_flash.to(I18n.t("#{locale_path}.update.done")) }

        it 'saves' do
          last_updated_at = Date.today - 4.days
          resource.update_attribute(:updated_at, last_updated_at)

          updated = resource
          updated.reload

          expect(updated.updated_at).not_to eq(last_updated_at)
        end

      end

      context 'invalid' do
        render_views

        let(:expected_flash) { I18n.t("#{locale_path}.update.error") }

        before do
          resource
          allow_any_instance_of(resource_model).to receive(:valid?).and_return(false)
          send_update_request
        end

        it 'set error flash' do
          expect(controller).to set_flash.now.to(expected_flash)
        end

        it 'render edit template' do
          expect(response).to render_template(:edit)
        end
      end
    end
  end

  private

  def send_update_request
    if respond_to?(:request_params)
      _params = request_params.merge(id: resource.id)
      patch :update, params: valid_params.merge(_params), id: resource.id
    else
      patch :update, params: valid_params.merge(id: resource.id)
    end
  end

  def controller_resource
    controller.send(resource_symbol)
  end

  def resource_symbol
    controller.try(:send, :resource_symbol) || resource_name.to_sym
  end

  def resource_name
    controller.controller_name.singularize
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
