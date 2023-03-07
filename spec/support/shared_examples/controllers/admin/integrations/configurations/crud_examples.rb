# Shared example para controllers de configuração de integração em admin

shared_examples_for 'controllers/admin/integrations/configurations/crud' do
  let(:user) { create(:user, :admin) }

  let(:resource_id) { "integration_#{integration_id}_configuration" }

  let(:resources) { create_list(resource_id, 1) }

  let(:configuration) { resources.first }

  # supports_creditor -> supports.creditor
  let(:default_integration_id_locale) { integration_id.to_s.split('_').join('.') }

  # real_states -> real_states
  let(:integration_id_locale) do
    respond_to?(:custom_integration_id_locale) ? custom_integration_id_locale : default_integration_id_locale
  end

  let(:valid_params) { { configuration: attributes_for(resource_id) } }

  it_behaves_like 'controllers/admin/base/show'
  it_behaves_like 'controllers/admin/base/edit'
  it_behaves_like 'controllers/admin/base/update'

  describe '#import' do
    before { sign_in(user) }

    describe 'invoke call method' do
      it 'calls importer api' do
        expect(Integration::Importers::Import).to receive(:call).with(integration_id, configuration.id)
        post :import, params: { id: configuration.id }

        expect(response).to redirect_to(controller.send(:resource_show_path))

        expect(controller).to set_flash.to(I18n.t("admin.integrations.#{integration_id_locale}.configurations.import.done"))
      end
    end
  end
end
