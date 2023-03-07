require 'rails_helper'

describe Transparency::SocietyMobileAppsController do

  let(:mobile_app) { create(:mobile_app) }

  describe '#index' do

    context 'template' do
      before { get(:index) }

      render_views

      it { is_expected.to respond_with(:success) }
      it { is_expected.to render_template(:index) }
    end

    context 'helper methods' do
      before { get(:index) }

      it 'transparency_apps' do
        mobile_app_1 = create(:mobile_app, official: false)
        mobile_app_2 = create(:mobile_app, official: true)

        expect(controller.mobile_apps).to eq([mobile_app_1])
      end
    end

    context 'search' do
      it 'name case insensitive' do
        filtered = create(:mobile_app, name: 'filtered', official: false)
        mobile_app

        get(:index, params: { search: 'filTer' })

        expect(controller.mobile_apps).to eq([filtered])
      end
    end
  end
end
