require 'rails_helper'

describe RegistrationsController do
  before { @request.env['devise.mapping'] = Devise.mappings[:user] }

  context 'new' do
    before { get(:new) }

    it 'breadcrumbs' do
      expected = [
        { title: I18n.t('home.index.breadcrumb_title'), url: root_path },
        { title: I18n.t('registrations.new.title'), url: '' }
      ]

      expect(controller.breadcrumbs).to eq(expected)
    end
  end

  context 'create' do
    before do
      post(:create, params: { user: { name: '' }})
    end

    context 'helper methods' do
      it 'breadcrumbs' do
        expected = [
          { title: I18n.t('home.index.breadcrumb_title'), url: root_path },
          { title: I18n.t('registrations.create.title'), url: '' }
        ]

        expect(controller.breadcrumbs).to eq(expected)
      end
    end
  end
end
