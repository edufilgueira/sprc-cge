require 'rails_helper'

describe Api::V1::Users::SessionsController do
  include ResponseSpecHelper

  let(:user) { create(:user, :admin) }

  let(:valid_login) do
    {
      "user":
      {
        "email": user.email,
        "password": user.password
      }
    }
  end

  let(:invalid_login) do
    {
      "user":
      {
        "email": user.email,
        "password": user.password + "1"
      }
    }
  end

  before { @request.env["devise.mapping"] = Devise.mappings[:user] }

  describe '#create' do

    context 'on success login' do
      before { post(:create, params: valid_login) }
      it { is_expected.to respond_with :success } #200
      it { expect(json["authentication_token"]).not_to be_empty }
    end

    context 'on fail login' do
      before { post(:create, params: invalid_login) }
      it { is_expected.to respond_with :unauthorized } #401
      it { expect(json["message"]).to eq I18n.t('app.unauthorized_message') }
    end
  end


  describe '#destroy' do
    let(:user) { create(:user) }
    let(:token) { Tiddle.create_and_return_token(user, request) }
    let(:invalid_token) { token + '0' }

    before { request.headers['X-USER-EMAIL'] = user.email }

    context 'unauthorized' do

      before do
        request.headers['X-USER-TOKEN'] = invalid_token
        delete(:destroy)
      end

      it { is_expected.to respond_with :unauthorized } #401
      it { expect(json["message"]).to eq I18n.t('app.unauthorized_message') }
    end

    context 'authorized' do
      before do
        request.headers['X-USER-TOKEN'] = token
        delete :destroy
      end

      it { is_expected.to respond_with :no_content } #204
    end
  end
end
