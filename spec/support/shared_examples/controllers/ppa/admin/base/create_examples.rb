# Shared example para action create de base controllers em ppa/admin
#
# @param admin [PPA::Administrator] to be signed_in with devise
# @param valid_params [Hash] all params required to create a resource
# @param request_params [Hash] any param to be passed to the request

shared_examples_for 'controllers/ppa/admin/base/create' do
  describe '#create' do
    context 'unauthorized' do
      before { send_create_request }

      it { is_expected.to redirect_to(new_ppa_admin_session_path) }
    end

    context 'authorized' do
      before { sign_in(admin) }

      context 'persistence' do
        it 'saves' do
          expect { send_create_request }.to change(resource_model, :count).by(1)
        end
      end

      context 'valid' do
        before { send_create_request }

        it 'set flash massage' do
          expected_flash = I18n.t("#{locale_path}.create.done")
          expect(controller).to set_flash.to(expected_flash)
        end

        it 'dont have errors' do
          resource = controller_resource
          expect(resource.errors.full_messages).to be_empty
        end

        it 'redirects' do
          expect(response).to redirect_to(controller.send(:resource_show_path))
        end
      end

      context 'invalid' do
        render_views

        before { allow_any_instance_of(resource_model).to receive(:valid?).and_return(false) }

        it 'doesnt save' do
          expect { send_create_request }.to_not change(resource_model, :count)
        end

        context 'alerts and redirects' do
          let(:expected_flash) { I18n.t("#{locale_path}.create.error") }

          before { send_create_request }

          it { expect(response).to render_template("#{view_path}/new") }
          it { expect(controller).to set_flash.now.to(expected_flash) }
        end
      end
    end
  end

  private

  def send_create_request
    if respond_to?(:request_params)
      post :create, params: valid_params.merge(request_params)
    else
      post :create, params: valid_params
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
