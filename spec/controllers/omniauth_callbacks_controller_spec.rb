require 'rails_helper'

describe OmniauthCallbacksController, type: :controller do
  describe 'facebook' do
    let(:omniauth) do
      a = OmniAuth::AuthHash.new
      a.provider = 'Facebook'
      a.uid = '123456'
      a.info = OmniAuth::AuthHash.new
      a.info.name = 'Teste 123'
      a.info.email = 'example@example.com'
      a
    end

    let(:auth) { omniauth }

    before do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      @request.env['omniauth.auth'] = auth
      post :facebook
    end

    it { is_expected.to redirect_to(platform_root_path) }

    describe 'invalid' do
      let(:auth) do
        omniauth.info.email = nil

        omniauth
      end

      it { is_expected.to redirect_to(new_user_registration_url) }
    end

  end
end
