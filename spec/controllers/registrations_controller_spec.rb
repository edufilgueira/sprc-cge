require 'rails_helper'

describe RegistrationsController do

  let(:user) { create(:user, :user) }

  let(:permitted_params) do
    [
      :document,
      :document_type,
      :email,
      :email_confirmation,
      :name,
      :password,
      :password_confirmation,
      :person_type,
      :education_level,
      :birthday,
      :server,
      :city_id
    ]
  end

  before { @request.env['devise.mapping'] = Devise.mappings[:user] }

  # garante que o controller tá incluíndo seu breadcrumb
  it { is_expected.to be_kind_of(Registrations::Breadcrumbs) }

  describe '#new' do
    context 'template' do
      render_views

      it 'layout and view' do
        get :new
        expect(response).to render_with_layout('application')
        expect(response).to render_template('registrations/new')
        expect(response).to render_template('registrations/_form')
      end
    end
  end

  describe '#create' do
    let(:valid_params) do
      user = build(:user).attributes
      user['password'] = 'Abc123!@#'
      user['password_confirmation'] = user['password']
      user['email_confirmation'] = user['email']

      { user: user }.with_indifferent_access
    end

    let(:invalid_params) { { user: attributes_for(:user, :invalid) } }

    it 'permits params' do
      should permit(*permitted_params).
        for(:create, params: valid_params ).on(:user)

    end

    context 'valid' do
      it 'salva e redireciona para pagina inicial' do
        expect do
          post(:create, params: valid_params)

          expect(controller).to redirect_to(root_path)

          expect(controller).to set_flash

        end.to change(User, :count).by(1)
      end

      context 'ticket_type' do

        before { post(:create, params: valid_params_with_ticket_type) }

        context 'default' do
          let(:valid_params_with_ticket_type) { valid_params }

          it { expect(controller).to redirect_to(root_path) }
        end

        context 'sou' do
          let(:valid_params_with_ticket_type) { valid_params.merge(ticket_type: :sou) }

          it { expect(controller).to redirect_to(root_path) }
        end

        context 'sic' do
          let(:valid_params_with_ticket_type) { valid_params.merge(ticket_type: :sic) }

          it { expect(controller).to redirect_to(root_path) }
        end
      end
    end

    context 'invalid' do
      it 'does not save and renders new' do
        expect do
          post :create, params: invalid_params

          expect(response).to render_with_layout('application')
          expect(response).to render_template('registrations/new')

        end.to change(User, :count).by(0)
      end

      it 'ensures email_confirmation validation' do
        valid_params[:user][:email_confirmation] = ''

        expect do
          post :create, params: valid_params
        end.to change(User, :count).by(0)
      end
    end
  end

  it_behaves_like 'controllers/base/single_authentication_guard' do
    let(:resource) { create(:user) }
  end
end
