require 'rails_helper'

describe Platform::UsersController do

  let(:user) { create(:user) }

  let(:permitted_params) do
    [
      :name,
      :email,
      :email_confirmation,
      :document_type,
      :document,
      :password,
      :password_confirmation,
      :education_level,
      :birthday,
      :server,
      :city_id,
      notification_roles: User::NOTIFICATION_ROLES
    ]
  end

  describe "#edit" do
    context 'unauthorized' do
      before { get(:edit, params: { id: user }) }

      it { is_expected.to redirect_to(new_user_session_path) }

      context 'logged' do
        it 'edit another user' do
          another_user = create(:user)

          sign_in(user)
          get(:edit, params: { id: another_user }) 
          is_expected.to respond_with(:forbidden)
        end

      end
    end

    context 'authorized' do
      before { sign_in(user) && get(:edit, params: { id: user }) }

      context 'template' do
        render_views

        it { is_expected.to respond_with(:success) }
        it { is_expected.to render_template(:edit) }
        it { is_expected.to render_template('platform/users/_form') }
      end

      context 'helper methods' do
        it 'user' do
          expect(controller.user).to eq(user)
        end
      end

      
    end
  end

  describe '#update' do
    let(:valid_user) { user }

    let(:valid_user_attributes) { valid_user.attributes }
    let(:invalid_user_attributes) { attributes_for(:user, :invalid) }
    let(:valid_user_params) { { id: user, user: valid_user_attributes } }
    let(:invalid_user_params) { { id: user, user: invalid_user_attributes } }

    context 'unauthorized' do
      before { patch(:update, params: valid_user_params) }

      it { is_expected.to redirect_to(new_user_session_path) }
    end

    context 'authorized' do
      before { sign_in(user) }

      it 'permits user params' do
        should permit(*permitted_params).
          for(:update, params: valid_user_params ).on(:user)
      end

      context 'valid' do
        it 'saves' do
          valid_user_params[:user]["name"] = 'new name'
          valid_user_params[:user]["email"] = 'new-email@example.com'
          valid_user_params[:user]["email_confirmation"] = valid_user_params[:user]["email"]

          # Ao trocar o endereço de  e-mail, o mecanismo de confirmação é ativado - envia-se um
          # e-mail de confirmação ao novo endereço
          expect_any_instance_of(User).to receive(:send_confirmation_instructions).once.and_call_original

          patch(:update, params: valid_user_params)

          valid_user.reload

          expected_flash = I18n.t('platform.users.update.done',
            title: valid_user.title)

          expect(valid_user.name).to eq('new name')
          # Com o módulo :confirmable, a troca de e-mail dispara um novo e-mail de confirmação
          # (ao novo endereço).
          # expect(valid_user.email).to eq('new-email@example.com')
          # -> Para evitar e-mail e reconfirmação: https://github.com/plataformatec/devise/issues/2318
          expect(valid_user.unconfirmed_email).to eq('new-email@example.com')
          expect(controller).to set_flash.to(expected_flash)
          expect(response).to redirect_to(edit_platform_user_path(user))
        end
      end

      context 'invalid' do
        render_views

        it 'does not save' do
          patch(:update, params: invalid_user_params)
          expect(response).to render_template(:edit)
        end
      end
    end
  end

end
