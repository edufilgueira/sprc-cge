require 'rails_helper'

describe PPA::Admin::Auth::ConfirmationsController, type: :controller do

  before { @request.env['devise.mapping'] = Devise.mappings[:ppa_admin] }


  describe '#show' do

    subject(:get_show) { get :show, params: { confirmation_token: confirmation_token } }

    context 'when confirmation_token is not valid' do
      let(:confirmation_token) { 'invalid' }

      it { is_expected.to respond_with_not_found }
    end

    context 'when confirmation_token is valid' do
      let!(:ppa_admin) { create :ppa_admin, :unconfirmed }
      let!(:confirmation_token) { ppa_admin.confirmation_token }


      context 'and ppa_admin is unconfirmed' do
        # renderiza o template, que será um form para definição da senha!
        it { is_expected.to be_succes.and render_template :show }
      end

      context 'and ppa admin is confirming a newly updated e-mail' do
        before { ppa_admin.update_column :unconfirmed_email, 'changed-email@example.com' }

        it 'confirms the ppa_admin new e-mail' do
          expect do
            get_show
            ppa_admin.reload
          end.to change { ppa_admin.unconfirmed_email }.from('changed-email@example.com').to(nil)
            .and change { ppa_admin.email }.to('changed-email@example.com')

          expect(response).to be_a_redirect
        end
      end

      context 'and ppa_admin is confirmed' do
        # XXX vamos confirmar o `ppa_admin` aqui para que o `confirmation_token` ainda seja criado
        # - com ppa_admin inicialmente :unconfirmed - e depois garantindo que ele está confirmado,
        # para que os parâmetros da request estejam como desejado.
        before do
          ppa_admin.skip_confirmation_notification!
          ppa_admin.confirm
        end

        it 'redirect the ppa_admin to login page' do
          get_show

          expect(response).to be_a_redirect
        end
      end
    end

  end # #show


  describe '#update' do

    let(:ppa_admin) { create :ppa_admin, :unconfirmed }
    let(:confirmation_token) { ppa_admin.confirmation_token }
    let(:params) do
      {
        confirmation_token: confirmation_token,
        ppa_admin: {
          password: 'secretum',
          password_confirmation: 'secretum'
        }
      }
    end
    subject(:patch_update) { patch :update, params: params }

    context 'parameter filtering' do
      it 'permits password and confirmation' do
        expect(patch_update).to permit(:password, :password_confirmation)
          .for(:update, params: { params: params })  # aguardando shoulda-matcher v4.0 para fix do `params: params`
          .on(:ppa_admin)
      end
    end

    context 'when confirmation_token is not valid' do
      let(:confirmation_token) { 'invalid' }

      it { is_expected.to respond_with_not_found }
    end

    context 'when password is not supplied' do
      before { params[:ppa_admin].merge!(password: '', password_confirmation: nil) }

      it 'does not confirm the ppa_admin' do
        expect do
          patch_update
          ppa_admin.reload
        end.not_to change { ppa_admin.confirmed? }
      end

      it 'does not update ppa_admin password' do
        expect do
          patch_update
          ppa_admin.reload
        end.not_to change { ppa_admin.encrypted_password }
      end

      it { is_expected.to render_template :show }
    end

    context 'when password does not match' do
      before do
        params.merge! ppa_admin: {
                        password: 'something-secret',
                        password_confirmation: 'zomething-zecret'
                      }
      end

      it 'does not confirm the ppa_admin' do
        expect do
          patch_update
          ppa_admin.reload
        end.not_to change { ppa_admin.confirmed? }
      end

      it 'does not update ppa_admin password' do
        expect do
          patch_update
          ppa_admin.reload
        end.not_to change { ppa_admin.encrypted_password }
      end

      it { is_expected.to render_template :show }
    end

    context 'on a successful scenario' do
      # confirmation_token, password and password_confirmation!
      it 'confirms the ppa_admin, updating his/her password' do
        expect do
          patch_update
          ppa_admin.reload
        end.to change { ppa_admin.confirmed_at }.from(nil)
          .and change { ppa_admin.encrypted_password }

        expect(ppa_admin).to be_confirmed
        expect(response).to be_a_redirect
      end
    end

  end # #update

end
