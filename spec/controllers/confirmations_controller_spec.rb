require 'rails_helper'

describe ConfirmationsController do

  before { @request.env['devise.mapping'] = Devise.mappings[:user] }


  describe '#show' do

    subject(:get_show) { get :show, params: { confirmation_token: confirmation_token } }

    context 'when confirmation_token is not valid' do
      let(:confirmation_token) { 'invalid' }

      it { is_expected.to respond_with_not_found }
    end

    context 'when confirmation_token is valid' do
      let!(:confirmation_token) { user.confirmation_token }

      context 'with user of type :user' do
        let!(:user) { create :user, :user, :unconfirmed }

        context 'and user is unconfirmed' do
          # autentica e redireciona para "login"
          it 'redirect to login page' do
            get_show
            expect(response).to be_a_redirect
          end
        end

        context 'and user is confirming a newly updated e-mail' do
          before { user.update_column :unconfirmed_email, 'changed-email@example.com' }

          it 'confirms the user new e-mail' do
            expect do
              get_show
              user.reload
            end.to change { user.unconfirmed_email }.from('changed-email@example.com').to(nil)
              .and change { user.email }.to('changed-email@example.com')

            expect(response).to be_a_redirect
          end
        end

        context 'and user is confirmed' do
          # XXX vamos confirmar o `user` aqui para que o `confirmation_token` ainda seja criado
          # - com user inicialmente :unconfirmed - e depois garantindo que ele está confirmado,
          # para que os parâmetros da request estejam como desejado.
          before do
            user.skip_confirmation_notification!
            user.confirm
          end

          it 'authenticates and redirects the user to login page' do
            get_show
            expect(response).to be_a_redirect
          end
        end
      end

      # Todos os demais tipos de usuário, exceto :user => %i[admin operator ...]
      (User.user_types.symbolize_keys.keys - [:user]).each do |user_type|

        context "with user of type #{user_type}" do
          let!(:user) { create :user, user_type, :unconfirmed }

          context 'and user is unconfirmed' do
            # renderiza o template, que será um form para definição da senha!
            it { is_expected.to be_succes.and render_template :show }
          end

          context 'and user is confirmed' do
            # XXX vamos confirmar o `user` aqui para que o `confirmation_token` ainda seja criado
            # - com user inicialmente :unconfirmed - e depois garantindo que ele está confirmado,
            # para que os parâmetros da request estejam como desejado.
            before do
              user.skip_confirmation_notification!
              user.confirm
            end

            it 'authenticates and redirects the user to login page' do
              get_show
              expect(response).to be_a_redirect
            end
          end


          context 'and user is confirming a newly updated e-mail' do
            before { user.update_column :unconfirmed_email, 'changed-email@example.com' }

            it 'confims the user new e-mail' do
              expect do
                get_show
                user.reload
              end.to change { user.unconfirmed_email }.from('changed-email@example.com').to(nil)
                .and change { user.email }.to('changed-email@example.com')

              expect(response).to be_a_redirect
            end
          end

        end # user_type context

      end # for each User.user_types
    end

  end # #show


  describe '#update' do

    User.user_types.symbolize_keys.keys.each do |user_type|

      context "with user of type #{user_type}" do
        let(:user) { create :user, user_type, :unconfirmed }
        let(:confirmation_token) { user.confirmation_token }
        let(:params) do
          {
            confirmation_token: confirmation_token,
            user: {
              password: 'Secret123@',
              password_confirmation: 'Secret123@'
            }
          }
        end
        subject(:patch_update) { patch :update, params: params }

        context 'parameter filtering' do
          it 'permits password and confirmation' do
            expect(patch_update).to permit(:password, :password_confirmation)
              .for(:update, params: { params: params })  # aguardando shoulda-matcher v4.0 para fix do `params: params`
              .on(:user)
          end
        end

        context 'when confirmation_token is not valid' do
          let(:confirmation_token) { 'invalid' }

          it { is_expected.to respond_with_not_found }
        end

        context 'when password is not supplied' do
          before { params[:user].merge!(password: '', password_confirmation: nil) }

          it 'does not confirm the user' do
            expect do
              patch_update
              user.reload
            end.not_to change { user.confirmed? }
          end

          it 'does not update user password' do
            expect do
              patch_update
              user.reload
            end.not_to change { user.encrypted_password }
          end

          it { is_expected.to render_template :show }
        end

        context 'when password does not match' do
          before do
            params.merge! user: {
                            password: 'something-secret',
                            password_confirmation: 'zomething-zecret'
                          }
          end

          it 'does not confirm the user' do
            expect do
              patch_update
              user.reload
            end.not_to change { user.confirmed? }
          end

          it 'does not update user password' do
            expect do
              patch_update
              user.reload
            end.not_to change { user.encrypted_password }
          end

          it { is_expected.to render_template :show }
        end

        context 'on a successful scenario' do
          # confirmation_token, password and password_confirmation!
          it 'confirms the user, updating his/her password' do
            expect do
              patch_update
              user.reload
            end.to change { user.confirmed_at }.from(nil)
              .and change { user.encrypted_password }

            expect(user).to be_confirmed
            expect(response).to be_a_redirect
          end
        end

      end  # context "when user is #{user_type}""

    end # for each User.user_types

  end # #update

end
