require 'rails_helper'

describe Admin::RedeOuvirOrgansController do

  let(:user) { create(:user, :admin) }
  let(:organ) { create(:rede_ouvir_organ) }

  context 'index' do
    before { sign_in(user) && get(:index) }

    it 'breadcrumbs' do
      expected = [
        { title: I18n.t('admin.home.index.title'), url: admin_root_path },
        { title: I18n.t('admin.rede_ouvir_organs.index.title'), url: '' }
      ]

      expect(controller.breadcrumbs).to eq(expected)
    end
  end

  context 'new' do
    before { sign_in(user) && get(:new) }

    it 'breadcrumbs' do
      expected = [
        { title: I18n.t('admin.home.index.title'), url: admin_root_path },
        { title: I18n.t('admin.rede_ouvir_organs.index.title'), url: admin_rede_ouvir_organs_path },
        { title: I18n.t('admin.rede_ouvir_organs.new.title'), url: '' }
      ]

      expect(controller.breadcrumbs).to eq(expected)
    end
  end

  context 'create' do
    let(:invalid_params) { { organ: attributes_for(:organ, :invalid) } }

    before { sign_in(user) && post(:create, params: invalid_params) }

    context 'helper methods' do
      it 'breadcrumbs' do
        expected = [
          { title: I18n.t('admin.home.index.title'), url: admin_root_path },
          { title: I18n.t('admin.rede_ouvir_organs.index.title'), url: admin_rede_ouvir_organs_path },
          { title: I18n.t('admin.rede_ouvir_organs.create.title'), url: '' }
        ]

        expect(controller.breadcrumbs).to eq(expected)
      end
    end
  end

  context 'show' do
    before { sign_in(user) && get(:show, params: { id: organ }) }

    it 'breadcrumbs' do
      expected = [
        { title: I18n.t('admin.home.index.title'), url: admin_root_path },
        { title: I18n.t('admin.rede_ouvir_organs.index.title'), url: admin_rede_ouvir_organs_path },
        { title: organ.title, url: '' }
      ]

      expect(controller.breadcrumbs).to eq(expected)
    end
  end

  context 'edit' do
    before { sign_in(user) && get(:show, params: { id: organ }) }

    it 'breadcrumbs' do
      expected = [
        { title: I18n.t('admin.home.index.title'), url: admin_root_path },
        { title: I18n.t('admin.rede_ouvir_organs.index.title'), url: admin_rede_ouvir_organs_path },
        { title: organ.title, url: '' }
      ]

      expect(controller.breadcrumbs).to eq(expected)
    end
  end

  context 'update' do

    let(:invalid_organ) do
      invalid = organ
      invalid.name = nil
      invalid
    end
    let(:invalid_params) { { id: organ, rede_ouvir_organ: invalid_organ.attributes } }

    before { sign_in(user) && patch(:update, params: invalid_params) }

    it 'breadcrumbs' do
      expected = [
        { title: I18n.t('admin.home.index.title'), url: admin_root_path },
        { title: I18n.t('admin.rede_ouvir_organs.index.title'), url: admin_rede_ouvir_organs_path },
        { title: organ.title, url: '' }
      ]

      expect(controller.breadcrumbs).to eq(expected)
    end
  end
end
