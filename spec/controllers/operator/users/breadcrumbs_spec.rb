require 'rails_helper'

describe Operator::UsersController do

  let(:organ) { create(:executive_organ) }
  let(:user) { create(:user, :operator_sectoral, organ: organ) }
  let(:other_operator) { create(:user, :operator_sectoral, organ: organ) }

  context 'index' do
    before { sign_in(user) && get(:index) }

    it 'breadcrumbs' do
      expected = [
        { title: I18n.t('operator.home.index.title'), url: operator_root_path },
        { title: I18n.t('operator.users.index.title'), url: '' }
      ]

      expect(controller.breadcrumbs).to eq(expected)
    end
  end

  context 'new' do
    before { sign_in(user) && get(:new) }

    it 'breadcrumbs' do
      expected = [
        { title: I18n.t('operator.home.index.title'), url: operator_root_path },
        { title: I18n.t('operator.users.index.title'), url: operator_users_path },
        { title: I18n.t('operator.users.new.title'), url: '' }
      ]

      expect(controller.breadcrumbs).to eq(expected)
    end
  end

  context 'create' do
    let(:invalid_params) { { user: attributes_for(:user, :invalid) } }

    before { sign_in(user) && post(:create, params: invalid_params) }

    context 'helper methods' do
      it 'breadcrumbs' do
        expected = [
          { title: I18n.t('operator.home.index.title'), url: operator_root_path },
          { title: I18n.t('operator.users.index.title'), url: operator_users_path },
          { title: I18n.t('operator.users.create.title'), url: '' }
        ]

        expect(controller.breadcrumbs).to eq(expected)
      end
    end
  end

  context 'show' do
    before { sign_in(user) && get(:show, params: { id: other_operator }) }

    it 'breadcrumbs' do
      expected = [
        { title: I18n.t('operator.home.index.title'), url: operator_root_path },
        { title: I18n.t('operator.users.index.title'), url: operator_users_path },
        { title: other_operator.title, url: '' }
      ]

      expect(controller.breadcrumbs).to eq(expected)
    end
  end

  context 'edit' do
    before { sign_in(user) && get(:show, params: { id: other_operator }) }

    it 'breadcrumbs' do
      expected = [
        { title: I18n.t('operator.home.index.title'), url: operator_root_path },
        { title: I18n.t('operator.users.index.title'), url: operator_users_path },
        { title: other_operator.title, url: '' }
      ]

      expect(controller.breadcrumbs).to eq(expected)
    end
  end

  context 'update' do
    let(:operator_internal) { create(:user, :operator_internal, organ: user.organ) }
    let(:invalid_params) { { id: operator_internal, user: attributes_for(:user, :invalid) } }

    before { sign_in(user) && patch(:update, params: invalid_params) }

    it 'breadcrumbs' do
      expected = [
        { title: I18n.t('operator.home.index.title'), url: operator_root_path },
        { title: I18n.t('operator.users.index.title'), url: operator_users_path },
        { title: invalid_params[:user][:social_name], url: '' }
      ]

      expect(controller.breadcrumbs).to eq(expected)
    end
  end
end
