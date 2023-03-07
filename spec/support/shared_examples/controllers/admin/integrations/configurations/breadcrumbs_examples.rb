# Shared example para controllers de configuração de integração em admin

shared_examples_for 'controllers/admin/integrations/configurations/breadcrumbs' do

  let(:user) { create(:user, :admin) }

  let(:resource_id) { "integration_#{integration_id}_configuration" }

  let(:resources) { create_list(resource_id, 1) }

  let(:configuration) { resources.first }

  context 'show' do
    before { sign_in(user) && get(:show, params: { id: configuration }) }

    it 'breadcrumbs' do
      expected = [
        { title: I18n.t('admin.home.index.title'), url: admin_root_path },
        { title: I18n.t('admin.integrations.index.title'), url: admin_integrations_root_path },
        { title: configuration.title, url: '' }
      ]

      expect(controller.breadcrumbs).to eq(expected)
    end
  end

  context 'edit' do
    before { sign_in(user) && get(:show, params: { id: configuration.id }) }

    it 'breadcrumbs' do
      expected = [
        { title: I18n.t('admin.home.index.title'), url: admin_root_path },
        { title: I18n.t('admin.integrations.index.title'), url: admin_integrations_root_path },
        { title: configuration.title, url: '' }
      ]

      expect(controller.breadcrumbs).to eq(expected)
    end
  end

  context 'update' do
    let(:valid_params) { { id: configuration.id, configuration: configuration.attributes } }

    before { sign_in(user) && patch(:update, params: valid_params) }

    it 'breadcrumbs' do
      expected = [
        { title: I18n.t('admin.home.index.title'), url: admin_root_path },
        { title: I18n.t('admin.integrations.index.title'), url: admin_integrations_root_path },
        { title: configuration.title, url: '' }
      ]

      expect(controller.breadcrumbs).to eq(expected)
    end
  end
end
