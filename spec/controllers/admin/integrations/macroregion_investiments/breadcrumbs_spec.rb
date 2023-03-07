require 'rails_helper'

describe Admin::Integrations::MacroregionInvestimentsController do

  let(:user) { create(:user, :admin) }
  let(:purchase) { create(:integration_macroregions_macroregion_investiment) }

  context 'index' do
    before { sign_in(user) && get(:index) }

    it 'breadcrumbs' do
      expected = [
        { title: I18n.t('admin.home.index.title'), url: admin_root_path },
        { title: I18n.t('admin.integrations.index.title'), url: admin_integrations_root_path },
        { title: I18n.t('shared.transparency.macroregion_investiments.index.title'), url: '' }
      ]

      expect(controller.breadcrumbs).to eq(expected)
    end
  end
end
