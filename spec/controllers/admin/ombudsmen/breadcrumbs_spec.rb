require 'rails_helper'

describe Admin::OmbudsmenController do
  let(:user) { create(:user, :admin) }
  let(:ombudsman) { create(:ombudsman) }

  context 'index' do
    before { sign_in(user) && get(:index) }

    it 'breadcrumbs' do
      expected = [
        { title: I18n.t('admin.home.index.title'), url: admin_root_path },
        { title: I18n.t('admin.ombudsmen.index.title'), url: '' }
      ]

      expect(controller.breadcrumbs).to eq(expected)
    end
  end

  context 'new' do
    before { sign_in(user) && get(:new) }

    it 'breadcrumbs' do
      expected = [
        { title: I18n.t('admin.home.index.title'), url: admin_root_path },
        { title: I18n.t('admin.ombudsmen.index.title'), url: admin_ombudsmen_path },
        { title: I18n.t('admin.ombudsmen.new.title'), url: '' }
      ]

      expect(controller.breadcrumbs).to eq(expected)
    end
  end

  context 'create' do
    let(:invalid_params) { { ombudsman: attributes_for(:ombudsman, :invalid) } }

    before { sign_in(user) && post(:create, params: invalid_params) }

    context 'helper methods' do
      it 'breadcrumbs' do
        expected = [
          { title: I18n.t('admin.home.index.title'), url: admin_root_path },
          { title: I18n.t('admin.ombudsmen.index.title'), url: admin_ombudsmen_path },
          { title: I18n.t('admin.ombudsmen.create.title'), url: '' }
        ]

        expect(controller.breadcrumbs).to eq(expected)
      end
    end
  end

  context 'show' do
    before { sign_in(user) && get(:show, params: { id: ombudsman }) }

    it 'breadcrumbs' do
      expected = [
        { title: I18n.t('admin.home.index.title'), url: admin_root_path },
        { title: I18n.t('admin.ombudsmen.index.title'), url: admin_ombudsmen_path },
        { title: ombudsman.title, url: '' }
      ]

      expect(controller.breadcrumbs).to eq(expected)
    end
  end

  context 'edit' do
    before { sign_in(user) && get(:show, params: { id: ombudsman }) }

    it 'breadcrumbs' do
      expected = [
        { title: I18n.t('admin.home.index.title'), url: admin_root_path },
        { title: I18n.t('admin.ombudsmen.index.title'), url: admin_ombudsmen_path },
        { title: ombudsman.title, url: '' }
      ]

      expect(controller.breadcrumbs).to eq(expected)
    end
  end

  context 'update' do

    let(:invalid_ombudsman) do
      invalid = ombudsman
      invalid.title = ''
      invalid
    end
    let(:invalid_params) { { id: ombudsman, ombudsman: invalid_ombudsman.attributes } }

    before { sign_in(user) && patch(:update, params: invalid_params) }

    it 'breadcrumbs' do
      expected = [
        { title: I18n.t('admin.home.index.title'), url: admin_root_path },
        { title: I18n.t('admin.ombudsmen.index.title'), url: admin_ombudsmen_path },
        { title: ombudsman.title, url: '' }
      ]

      expect(controller.breadcrumbs).to eq(expected)
    end
  end
end
