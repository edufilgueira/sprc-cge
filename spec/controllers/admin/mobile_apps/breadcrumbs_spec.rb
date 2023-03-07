require 'rails_helper'

describe Admin::MobileAppsController do

  let(:user) { create(:user, :admin) }
  let(:mobile_app) { create(:mobile_app) }

  before { sign_in(user) }

  context 'index' do
    let(:expected) do
      [
        { title: I18n.t('admin.home.index.title'), url: admin_root_path },
        { title: I18n.t('admin.mobile_apps.index.title'), url: '' }
      ]
    end

    before { get(:index) }

    it { expect(controller.breadcrumbs).to eq(expected) }
  end

  context 'new' do
    let(:expected) do
      [
        { title: I18n.t('admin.home.index.title'), url: admin_root_path },
        { title: I18n.t('admin.mobile_apps.index.title'), url: admin_mobile_apps_path },
        { title: I18n.t('admin.mobile_apps.new.title'), url: '' }
      ]
    end

    before { get(:new) }

    it { expect(controller.breadcrumbs).to eq(expected) }
  end

  context 'create' do
    let(:expected) do
      [
        { title: I18n.t('admin.home.index.title'), url: admin_root_path },
        { title: I18n.t('admin.mobile_apps.index.title'), url: admin_mobile_apps_path },
        { title: I18n.t('admin.mobile_apps.create.title'), url: '' }
      ]
    end

    let(:invalid_params) { { mobile_app: attributes_for(:mobile_app, :invalid) } }

    before { post(:create, params: invalid_params) }

    it { expect(controller.breadcrumbs).to eq(expected) }
  end

  context 'edit' do
    let(:expected) do
      [
        { title: I18n.t('admin.home.index.title'), url: admin_root_path },
        { title: I18n.t('admin.mobile_apps.index.title'), url: admin_mobile_apps_path },
        { title: mobile_app.title, url: '' }
      ]
    end

    before { get(:edit, params: { id: mobile_app }) }

    it { expect(controller.breadcrumbs).to eq(expected) }
  end

  context 'update' do
    let(:expected) do
      [
        { title: I18n.t('admin.home.index.title'), url: admin_root_path },
        { title: I18n.t('admin.mobile_apps.index.title'), url: admin_mobile_apps_path },
        { title: '', url: '' }
      ]
    end

    let(:invalid_params) { { id: mobile_app, mobile_app: attributes_for(:mobile_app, :invalid) } }

    before { patch(:update, params: invalid_params) }

    it { expect(controller.breadcrumbs).to eq(expected) }
  end
end
