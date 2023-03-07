require 'rails_helper'

describe Admin::OpenData::DataSetsController do

  let(:user) { create(:user, :admin) }
  let(:data_set) { create(:data_set) }

  context 'index' do
    before { sign_in(user) && get(:index) }

    it 'breadcrumbs' do
      expected = [
        { title: I18n.t('admin.home.index.title'), url: admin_root_path },
        { title: I18n.t('admin.open_data.data_sets.index.title'), url: '' }
      ]

      expect(controller.breadcrumbs).to eq(expected)
    end
  end

  context 'new' do
    before { sign_in(user) && get(:new) }

    it 'breadcrumbs' do
      expected = [
        { title: I18n.t('admin.home.index.title'), url: admin_root_path },
        { title: I18n.t('admin.open_data.data_sets.index.title'), url: admin_open_data_data_sets_path },
        { title: I18n.t('admin.open_data.data_sets.new.title'), url: '' }
      ]

      expect(controller.breadcrumbs).to eq(expected)
    end
  end

  context 'create' do
    let(:invalid_params) { { data_set: attributes_for(:data_set, :invalid) } }

    before { sign_in(user) && post(:create, params: invalid_params) }

    context 'helper methods' do
      it 'breadcrumbs' do
        expected = [
          { title: I18n.t('admin.home.index.title'), url: admin_root_path },
          { title: I18n.t('admin.open_data.data_sets.index.title'), url: admin_open_data_data_sets_path },
          { title: I18n.t('admin.open_data.data_sets.create.title'), url: '' }
        ]

        expect(controller.breadcrumbs).to eq(expected)
      end
    end
  end

  context 'show' do
    before { sign_in(user) && get(:show, params: { id: data_set }) }

    it 'breadcrumbs' do
      expected = [
        { title: I18n.t('admin.home.index.title'), url: admin_root_path },
        { title: I18n.t('admin.open_data.data_sets.index.title'), url: admin_open_data_data_sets_path },
        { title: data_set.title, url: '' }
      ]

      expect(controller.breadcrumbs).to eq(expected)
    end
  end

  context 'edit' do
    before { sign_in(user) && get(:show, params: { id: data_set }) }

    it 'breadcrumbs' do
      expected = [
        { title: I18n.t('admin.home.index.title'), url: admin_root_path },
        { title: I18n.t('admin.open_data.data_sets.index.title'), url: admin_open_data_data_sets_path },
        { title: data_set.title, url: '' }
      ]

      expect(controller.breadcrumbs).to eq(expected)
    end
  end

  context 'update' do

    let(:invalid_data_set) do
      invalid = data_set
      invalid.organ = nil
      invalid
    end
    let(:invalid_params) { { id: data_set, data_set: invalid_data_set.attributes } }

    before { sign_in(user) && patch(:update, params: invalid_params) }

    it 'breadcrumbs' do
      expected = [
        { title: I18n.t('admin.home.index.title'), url: admin_root_path },
        { title: I18n.t('admin.open_data.data_sets.index.title'), url: admin_open_data_data_sets_path },
        { title: data_set.title, url: '' }
      ]

      expect(controller.breadcrumbs).to eq(expected)
    end
  end
end
