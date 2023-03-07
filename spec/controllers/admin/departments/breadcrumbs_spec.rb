require 'rails_helper'

describe Admin::DepartmentsController do

  let(:user) { create(:user, :admin) }
  let(:department) { create(:department) }

  context 'index' do
    before { sign_in(user) && get(:index) }

    it 'breadcrumbs' do
      expected = [
        { title: I18n.t('admin.home.index.title'), url: admin_root_path },
        { title: I18n.t('admin.departments.index.title'), url: '' }
      ]

      expect(controller.breadcrumbs).to eq(expected)
    end
  end

  context 'new' do
    before { sign_in(user) && get(:new) }

    it 'breadcrumbs' do
      expected = [
        { title: I18n.t('admin.home.index.title'), url: admin_root_path },
        { title: I18n.t('admin.departments.index.title'), url: admin_departments_path },
        { title: I18n.t('admin.departments.new.title'), url: '' }
      ]

      expect(controller.breadcrumbs).to eq(expected)
    end
  end

  context 'create' do
    let(:invalid_params) { { department: attributes_for(:department, :invalid) } }

    before { sign_in(user) && post(:create, params: invalid_params) }

    context 'helper methods' do
      it 'breadcrumbs' do
        expected = [
          { title: I18n.t('admin.home.index.title'), url: admin_root_path },
          { title: I18n.t('admin.departments.index.title'), url: admin_departments_path },
          { title: I18n.t('admin.departments.create.title'), url: '' }
        ]

        expect(controller.breadcrumbs).to eq(expected)
      end
    end
  end

  context 'show' do
    before { sign_in(user) && get(:show, params: { id: department }) }

    it 'breadcrumbs' do
      expected = [
        { title: I18n.t('admin.home.index.title'), url: admin_root_path },
        { title: I18n.t('admin.departments.index.title'), url: admin_departments_path },
        { title: department.title, url: '' }
      ]

      expect(controller.breadcrumbs).to eq(expected)
    end
  end

  context 'edit' do
    before { sign_in(user) && get(:show, params: { id: department }) }

    it 'breadcrumbs' do
      expected = [
        { title: I18n.t('admin.home.index.title'), url: admin_root_path },
        { title: I18n.t('admin.departments.index.title'), url: admin_departments_path },
        { title: department.title, url: '' }
      ]

      expect(controller.breadcrumbs).to eq(expected)
    end
  end

  context 'update' do
    let(:invalid_params) { { id: department, department: attributes_for(:department, :invalid) } }

    before { sign_in(user) && patch(:update, params: invalid_params) && department.assign_attributes(invalid_params[:department]) }

    it 'breadcrumbs' do
      expected = [
        { title: I18n.t('admin.home.index.title'), url: admin_root_path },
        { title: I18n.t('admin.departments.index.title'), url: admin_departments_path },
        { title: department.reload.title, url: '' }
      ]

      expect(controller.breadcrumbs).to eq(expected)
    end
  end
end
