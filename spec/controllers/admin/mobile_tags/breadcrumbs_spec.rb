require 'rails_helper'

describe Admin::MobileTagsController do

  let(:user) { create(:user, :admin) }
  let(:mobile_tag) { create(:mobile_tag) }

  before { sign_in(user) }

  context 'index' do
    let(:expected) do
      [
        { title: I18n.t('admin.home.index.title'), url: admin_root_path },
        { title: I18n.t('admin.mobile_tags.index.title'), url: '' }
      ]
    end

    before { get(:index) }

    it { expect(controller.breadcrumbs).to eq(expected) }
  end

  context 'new' do
    let(:expected) do
      [
        { title: I18n.t('admin.home.index.title'), url: admin_root_path },
        { title: I18n.t('admin.mobile_tags.index.title'), url: admin_mobile_tags_path },
        { title: I18n.t('admin.mobile_tags.new.title'), url: '' }
      ]
    end

    before { get(:new) }

    it { expect(controller.breadcrumbs).to eq(expected) }
  end

  context 'create' do
    let(:expected) do
      [
        { title: I18n.t('admin.home.index.title'), url: admin_root_path },
        { title: I18n.t('admin.mobile_tags.index.title'), url: admin_mobile_tags_path },
        { title: I18n.t('admin.mobile_tags.create.title'), url: '' }
      ]
    end

    let(:invalid_params) { { mobile_tag: attributes_for(:mobile_tag, :invalid) } }

    before { post(:create, params: invalid_params) }

    it { expect(controller.breadcrumbs).to eq(expected) }
  end

  context 'edit' do
    let(:expected) do
      [
        { title: I18n.t('admin.home.index.title'), url: admin_root_path },
        { title: I18n.t('admin.mobile_tags.index.title'), url: admin_mobile_tags_path },
        { title: mobile_tag.title, url: '' }
      ]
    end

    before { get(:edit, params: { id: mobile_tag }) }

    it { expect(controller.breadcrumbs).to eq(expected) }
  end

  context 'update' do
    let(:expected) do
      [
        { title: I18n.t('admin.home.index.title'), url: admin_root_path },
        { title: I18n.t('admin.mobile_tags.index.title'), url: admin_mobile_tags_path },
        { title: '', url: '' }
      ]
    end

    let(:invalid_params) { { id: mobile_tag, mobile_tag: attributes_for(:mobile_tag, :invalid) } }

    before { patch(:update, params: invalid_params) }

    it { expect(controller.breadcrumbs).to eq(expected) }
  end
end
