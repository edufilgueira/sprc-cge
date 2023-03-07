require 'rails_helper'

describe Admin::PagesController do

  let(:admin) { create(:user, :admin) }
  let(:page) { create(:page) }

  context 'index' do
    before { sign_in(admin) && get(:index) }

    it 'breadcrumbs' do
      expected = [
        { title: I18n.t('admin.home.index.title'), url: admin_root_path },
        { title: I18n.t('admin.pages.index.title'), url: '' }
      ]

      expect(controller.breadcrumbs).to eq(expected)
    end
  end

  context 'new' do
    before { sign_in(admin) && get(:new) }

    it 'breadcrumbs' do
      expected = [
        { title: I18n.t('admin.home.index.title'), url: admin_root_path },
        { title: I18n.t('admin.pages.index.title'), url: admin_pages_path },
        { title: I18n.t('admin.pages.new.title'), url: '' }
      ]

      expect(controller.breadcrumbs).to eq(expected)
    end
  end

  context 'create' do
    let(:invalid_params) { { page: attributes_for(:page, :invalid) } }

    before { sign_in(admin) && post(:create, params: invalid_params) }

    context 'helper methods' do
      it 'breadcrumbs' do
        expected = [
          { title: I18n.t('admin.home.index.title'), url: admin_root_path },
          { title: I18n.t('admin.pages.index.title'), url: admin_pages_path },
          { title: I18n.t('admin.pages.create.title'), url: '' }
        ]

        expect(controller.breadcrumbs).to eq(expected)
      end
    end
  end

  context 'show' do
    before { sign_in(admin) && get(:show, params: { id: page }) }

    it 'breadcrumbs' do
      expected = [
        { title: I18n.t('admin.home.index.title'), url: admin_root_path },
        { title: I18n.t('admin.pages.index.title'), url: admin_pages_path },
        { title: page.title, url: '' }
      ]

      expect(controller.breadcrumbs).to eq(expected)
    end
  end

  context 'edit' do
    before { sign_in(admin) && get(:show, params: { id: page }) }

    it 'breadcrumbs' do
      expected = [
        { title: I18n.t('admin.home.index.title'), url: admin_root_path },
        { title: I18n.t('admin.pages.index.title'), url: admin_pages_path },
        { title: page.title, url: '' }
      ]

      expect(controller.breadcrumbs).to eq(expected)
    end
  end

  context 'update' do
    let(:invalid_params) { { id: page, page: attributes_for(:page, :invalid) } }

    before { sign_in(admin) && patch(:update, params: invalid_params) }

    it 'breadcrumbs' do
      expected = [
        { title: I18n.t('admin.home.index.title'), url: admin_root_path },
        { title: I18n.t('admin.pages.index.title'), url: admin_pages_path },
        { title: page.title, url: '' }
      ]

      expect(controller.breadcrumbs).to eq(expected)
    end
  end
end
