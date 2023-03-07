require 'rails_helper'

describe Transparency::MobileAppsController do

  context 'index' do
    let(:expected) do
      [
        { title: I18n.t('transparency.home.index.title'), url: transparency_root_path },
        { title: I18n.t('transparency.mobile_apps.index.title'), url: '' }
      ]
    end

    before { get(:index) }

    it { expect(controller.breadcrumbs).to eq(expected) }
  end
end
