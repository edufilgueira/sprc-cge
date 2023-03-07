require 'rails_helper'

describe SessionsController do
  before { @request.env['devise.mapping'] = Devise.mappings[:user] }

  context 'new' do
    it 'breadcrumbs' do
      get(:new)

      expected = [
        { title: I18n.t('home.index.breadcrumb_title'), url: root_path },
        { title: I18n.t('sessions.new.title'), url: '' }
      ]

      expect(controller.breadcrumbs).to eq(expected)
    end

    # a página de sign_in (sessions/new) é compartilhada por:
    # 1) acessar minha conta
    # 2) links externos para Ouvidoria (parametro ticket_type=sou)
    # 3) links externos para SIC (parametro ticket_type=sic)
    #
    # Dependendo do propósito, temos que exibir títulos e breadcrumbs
    # específicos.

    describe 'for ticket_types' do
      it 'sou' do
        get(:new, params: { ticket_type: :sou })

        expected = [
          { title: I18n.t('home.index.breadcrumb_title'), url: root_path },
          { title: I18n.t('sessions.new.ticket_types.sou.title'), url: '' }
        ]

        expect(controller.breadcrumbs).to eq(expected)
      end

      it 'sic' do
        get(:new, params: { ticket_type: :sic })

        expected = [
          { title: I18n.t('home.index.breadcrumb_title'), url: root_path },
          { title: I18n.t('sessions.new.ticket_types.sic.title'), url: '' }
        ]

        expect(controller.breadcrumbs).to eq(expected)
      end

      it 'invalid' do
        get(:new, params: { ticket_type: :tipo_que_nao_existe })

        expected = [
          { title: I18n.t('home.index.breadcrumb_title'), url: root_path },
          { title: I18n.t('sessions.new.title'), url: '' }
        ]

        expect(controller.breadcrumbs).to eq(expected)
      end
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
          { title: I18n.t('sessions.create.title'), url: '' }
        ]

        expect(controller.breadcrumbs).to eq(expected)
      end
    end
  end
end
