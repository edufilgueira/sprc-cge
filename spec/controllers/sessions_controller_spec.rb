require 'rails_helper'

describe SessionsController do

  before { @request.env['devise.mapping'] = Devise.mappings[:user] }

  # garante que o controller tá incluíndo seu breadcrumb
  it { is_expected.to be_kind_of(Sessions::Breadcrumbs) }

  context 'template' do
    render_views

    it 'renders session layout and new template' do
      get :new
      expect(response).to render_template('sessions/new')
      expect(response).to render_template('sessions/_form')
    end
  end

  context 'helpers' do
    # O formulário de 'Acessar a conta' (sessions/new) é acessado pelo
    # usuário por 3 formas distintas:
    # 1) via 'Acessar sua conta'
    # 2) via 'Ouvidoria Digital' estando deslogado
    # 3) via 'Acesso à Informação' estando deslogado
    #
    # Alguns aspectos da página, como o título e breadcrumbs mudam
    # de acordo com as formas.

    describe '#title' do
      context 'when ticket_type sou' do
        it 'sets title based on ticket_type' do
          get :new, params: { ticket_type: :sou }

          expect(controller.title).to eq(I18n.t('sessions.new.ticket_types.sou.title'))
        end
      end

      context 'when ticket_type sic' do
        it 'sets title based on ticket_type for sic' do
          get :new, params: { ticket_type: :sic }

          expect(controller.title).to eq(I18n.t('sessions.new.ticket_types.sic.title'))
        end
      end

      context 'when ticket_type denunciation' do
        it 'sets title based on ticket_type for denunciation' do
          get :new, params: { ticket_type: :denunciation }

          expect(controller.title).to eq(I18n.t('sessions.new.ticket_types.denunciation.title'))
        end
      end

      context 'when invalid ticket_type' do
        it 'sets title based on ticket_type for invalid ticket_type' do
          get :new, params: { ticket_type: :tipo_inexistente }

          expect(controller.title).to eq(I18n.t('sessions.new.title'))
        end
      end
    end

    describe '#description' do
      context 'when ticket_type sou' do
        it 'sets description based on ticket_type' do
          get :new, params: { ticket_type: :sou }
          expect(controller.description).to eq(I18n.t('sessions.new.ticket_types.sou.description'))
        end
      end

      context 'when ticket_type sic' do
        it 'sets description based on ticket_type' do
          get :new, params: { ticket_type: :sic }

          expect(controller.description).to eq(I18n.t('sessions.new.ticket_types.sic.description'))
        end
      end

      context 'when ticket_type denunciation' do
        it 'sets description based on ticket_type' do
          get :new, params: { ticket_type: :denunciation }

          expect(controller.description).to eq(I18n.t('sessions.new.ticket_types.denunciation.description'))
        end
      end
    end
  end

  context 'admin' do
    let(:user) { create(:user, :admin) }

    it 'redirects on signed out' do
      delete(:destroy)
      expect(response).to redirect_to(new_user_session_path)
    end
  end

  context 'operator' do
    let(:user) { create(:user, :operator) }

    it 'redirects on signed out' do
      delete(:destroy)
      expect(response).to redirect_to(new_user_session_path)
    end
  end

  context 'user' do
    let(:user) { create(:user) }

    it 'redirects on signed out' do
      delete(:destroy)
      expect(response).to redirect_to(new_user_session_path)
    end

    it 'redirect to tickets controller with ticket_type' do
      post :create, params: { ticket_type: :sou, user: { email: user.email, password: user.password } }
      expect(response).to redirect_to(platform_tickets_path(ticket_type: :sou))
    end

    it 'redirects to sou tickets when ticket_type is not defined' do
      post :create, params: { user: { email: user.email, password: user.password } }
      expect(response).to redirect_to(platform_root_path)
    end

    it 'redirect to custom page' do
      redirect_to = edit_platform_user_path(user)

      get(:new, params: { redirect_to: redirect_to })
      post(:create, params: { user: { email: user.email, password: user.password } })

      expect(response).to redirect_to(redirect_to)
    end
  end

  it_behaves_like 'controllers/base/single_authentication_guard' do
    let(:resource) { create(:user) }
  end
end
