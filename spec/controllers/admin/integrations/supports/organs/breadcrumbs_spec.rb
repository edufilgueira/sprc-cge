require 'rails_helper'

describe Admin::Integrations::Supports::OrgansController do

  let(:user) { create(:user, :admin) }
  let(:organ) { create(:integration_supports_organ) }

  context 'index' do
    before { sign_in(user) && get(:index) }

    it 'breadcrumbs' do
      expected = [
        { title: I18n.t('admin.home.index.title'), url: admin_root_path },
        { title: I18n.t('admin.integrations.index.title'), url: admin_integrations_root_path },
        { title: I18n.t('admin.integrations.supports.organs.index.title'), url: '' }
      ]

      expect(controller.breadcrumbs).to eq(expected)
    end
  end

  context 'show' do
    before { sign_in(user) && get(:show, params: { id: organ }) }

    it 'breadcrumbs' do
      expected = [
        { title: I18n.t('admin.home.index.title'), url: admin_root_path },
        { title: I18n.t('admin.integrations.index.title'), url: admin_integrations_root_path },
        { title: I18n.t('admin.integrations.supports.organs.index.title'), url: admin_integrations_supports_organs_path },
        { title: organ.title.truncate(20), url: '' }
      ]

      expect(controller.breadcrumbs).to eq(expected)
    end
  end
end
