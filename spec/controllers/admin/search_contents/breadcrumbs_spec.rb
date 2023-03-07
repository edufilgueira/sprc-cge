require 'rails_helper'

describe Admin::SearchContentsController do

  let(:user) { create(:user, :admin) }
  let(:search_content) { create(:search_content) }

  context 'index' do
    before { sign_in(user) && get(:index) }

    it 'breadcrumbs' do
      expected = [
        { title: I18n.t('admin.home.index.title'), url: admin_root_path },
        { title: I18n.t('admin.search_contents.index.title'), url: '' }
      ]

      expect(controller.breadcrumbs).to eq(expected)
    end
  end

  context 'new' do
    before { sign_in(user) && get(:new) }

    it 'breadcrumbs' do
      expected = [
        { title: I18n.t('admin.home.index.title'), url: admin_root_path },
        { title: I18n.t('admin.search_contents.index.title'), url: admin_search_contents_path },
        { title: I18n.t('admin.search_contents.new.title'), url: '' }
      ]

      expect(controller.breadcrumbs).to eq(expected)
    end
  end

  context 'create' do
    let(:invalid_params) { { search_content: attributes_for(:search_content, :invalid) } }

    before { sign_in(user) && post(:create, params: invalid_params) }

    context 'helper methods' do
      it 'breadcrumbs' do
        expected = [
          { title: I18n.t('admin.home.index.title'), url: admin_root_path },
          { title: I18n.t('admin.search_contents.index.title'), url: admin_search_contents_path },
          { title: I18n.t('admin.search_contents.create.title'), url: '' }
        ]

        expect(controller.breadcrumbs).to eq(expected)
      end
    end
  end

  context 'show' do
    before { sign_in(user) && get(:show, params: { id: search_content }) }

    it 'breadcrumbs' do
      expected = [
        { title: I18n.t('admin.home.index.title'), url: admin_root_path },
        { title: I18n.t('admin.search_contents.index.title'), url: admin_search_contents_path },
        { title: search_content.title, url: '' }
      ]

      expect(controller.breadcrumbs).to eq(expected)
    end
  end

  context 'edit' do
    before { sign_in(user) && get(:show, params: { id: search_content }) }

    it 'breadcrumbs' do
      expected = [
        { title: I18n.t('admin.home.index.title'), url: admin_root_path },
        { title: I18n.t('admin.search_contents.index.title'), url: admin_search_contents_path },
        { title: search_content.title, url: '' }
      ]

      expect(controller.breadcrumbs).to eq(expected)
    end
  end

  context 'update' do
    let(:valid_params) { { id: search_content.id, search_content: search_content.attributes } }

    before { sign_in(user) && patch(:update, params: valid_params) }

    it 'breadcrumbs' do
      expected = [
        { title: I18n.t('admin.home.index.title'), url: admin_root_path },
        { title: I18n.t('admin.search_contents.index.title'), url: admin_search_contents_path },
        { title: search_content.title, url: '' }
      ]

      expect(controller.breadcrumbs).to eq(expected)
    end
  end
end
