require 'rails_helper'

describe PPA::Admin::AdministratorsController do
  let(:administrator) { create :ppa_administrator }

  before { @request.env['devise.mapping'] = Devise.mappings[:ppa_admin] }

  context 'index' do
    before { get :index }

    it 'breadcrumbs' do
      expected = [
        { title: I18n.t('ppa.admin.breadcrumbs.home.index.title'), url: ppa_admin_root_path },
        { title: I18n.t('ppa.admin.breadcrumbs.administrators.index.title'), url: '' },
      ]

      expect(controller.breadcrumbs).to eq(expected)
    end
  end

  context 'new' do
    before { get(:new) }

    it 'breadcrumbs' do
      expected = [
        { title: I18n.t('ppa.admin.breadcrumbs.home.index.title'), url: ppa_admin_root_path },
        { title: I18n.t('ppa.admin.breadcrumbs.administrators.index.title'), url: ppa_admin_administrators_path },
        { title: I18n.t('ppa.admin.breadcrumbs.administrators.new.title'), url: '' }
      ]

      expect(controller.breadcrumbs).to eq(expected)
    end
  end

  [:show, :edit].each do |action|
    context action.to_s do
      before { get action, params: {id: administrator.id} }

      it 'breadcrumbs' do
        expected = [
          { title: I18n.t('ppa.admin.breadcrumbs.home.index.title'), url: ppa_admin_root_path },
          { title: I18n.t('ppa.admin.breadcrumbs.administrators.index.title'), url: ppa_admin_administrators_path },
          { title: administrator.name, url: '' }
        ]

        expect(controller.breadcrumbs).to eq(expected)
      end
    end
  end
end
