require 'rails_helper'

describe PasswordsController do

  before { @request.env['devise.mapping'] = Devise.mappings[:user] }

  it 'renders session layout and new template' do
    get :new
    expect(response).to render_template('passwords/new')
  end

  describe 'redirects after changing passwords' do

    let(:user) do
      user = build(:user)

      original_token = '1234'
      reset_password_token = Devise.token_generator.digest(User, :reset_password_token, original_token)
      user.reset_password_token = reset_password_token
      user.reset_password_sent_at = DateTime.now

      user
    end

    it 'admin' do
      user.user_type = :admin
      user.save

      put(:update, params: { user: { reset_password_token: '1234', password: 'Secret123@', password_confirmation: 'Secret123@' } })

      expect(response).to redirect_to(admin_root_path)
    end

    it 'operator' do
      user.user_type = :operator
      user.operator_type = :cge
      user.denunciation_tracking = false
      user.save

      put(:update, params: { user: { reset_password_token: '1234', password: 'Secret123@', password_confirmation: 'Secret123@' } })

      expect(response).to redirect_to(operator_root_path)
    end

    it 'user' do
      user.user_type = :user
      user.save

      put(:update, params: { user: { reset_password_token: '1234', password: 'Secret123@', password_confirmation: 'Secret123@' } })

      expect(response).to redirect_to(platform_root_path)
    end
  end


  describe '#update' do
    context 'when user is not confirmed' do
      let!(:user) { create :user, User.user_types.keys.sample.to_sym, :unconfirmed }
      # XXX é o token do e-mail! Não Realtor#reset_password_token
      let!(:token) { user.send_reset_password_instructions }

      let(:params) do
        {
          user: {
            reset_password_token: token,
            password: 'Secret123@',
            password_confirmation: 'Secret123@'
          }
        }
      end
      subject(:patch_update) { patch :update, params: params }

      it 'updates user passwords and confirms him/her' do
        expect do
          patch_update
          user.reload
        end.to change { user.reset_password_token }.to(nil)
          .and change { user.encrypted_password }
          .and change { user.confirmed? }.from(false).to(true)
      end
    end
  end
end
