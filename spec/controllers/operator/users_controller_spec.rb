require 'rails_helper'

describe Operator::UsersController do

  let(:other_operator) { create(:user, :operator_cge) }

  let(:view_context) { controller.view_context }

  let(:organ) { create(:executive_organ) }
  let(:subnet) { create(:subnet) }

  let(:operator) { create(:user, :operator_sectoral, organ: organ) }

  let(:operator_cge) { create(:user, :operator_cge) }

  let(:operator_chief) { create(:user, :operator_chief, organ: organ) }

  let(:another_operator) { create(:user, :operator_sectoral, organ: organ) }

  let(:operator_internal) { create(:user, :operator_internal, organ: organ) }

  let(:operator_subnet_internal) { create(:user, :operator_subnet_internal, organ: organ, subnet: subnet) }

  let(:operator_subnet) { create(:user, :operator_subnet, organ: organ, subnet: subnet) }

  let(:operator_subnet_chief) { create(:user, :operator_subnet_chief, organ: organ, subnet: subnet) }

  let(:permitted_params) do
    [
      :name,
      :social_name,
      :gender,
      :document,
      :document_type,
      :email,
      :email_confirmation,
      :password,
      :password_confirmation,
      :internal_subnet,
      :denunciation_tracking,
      :organ_id,
      :department_id,
      :sub_department_id,
      :subnet_id,
      :operator_type,
      :education_level,
      :birthday,
      :server,
      :city_id,
      :positioning,
      notification_roles: User::NOTIFICATION_ROLES
    ]
  end

  describe '#index' do
    context 'unauthorized' do
      before { get(:index) }

      it { is_expected.to redirect_to(new_user_session_path) }
    end

    context 'authorized' do

      context 'sectoral' do
        before { sign_in(operator) && get(:index) }

        context 'template' do
          render_views

          it { is_expected.to respond_with(:success) }
          it { is_expected.to render_template(:index) }
          it { is_expected.to render_template('operator/users/_filters') }
        end

        context 'helper methods' do

          context 'users' do
            it 'for cge' do
              create(:user, :admin)
              create(:user, :user)
              other_cge = create(:user, :operator_cge)
              operator_internal = create(:user, :operator_internal)
              another_operator
              operator_chief
              operator_subnet_internal
              operator_subnet
              operator_subnet_chief

              sign_out(operator) && sign_in(operator_cge) && get(:index)

              expect(view_context.users).to match_array([
                operator, operator_cge, other_cge, another_operator,
                operator_internal, operator_chief, operator_subnet_internal,
                operator_subnet, operator_subnet_chief
              ])
            end

            it 'for sou_sectoral' do
              create(:user, :admin)
              create(:user, :user)
              create(:user, :operator_chief)
              operator_internal = create(:user, :operator_internal, organ: organ)
              another_operator
              operator_subnet_internal
              operator_subnet

              expect(view_context.users).to match_array([
                operator, another_operator, operator_internal,
                operator_subnet_internal, operator_subnet
              ])
            end

            it 'for subnet' do
              create(:user, :admin)
              create(:user, :user)
              create(:user, :operator_chief)
              operator_internal = create(:user, :operator_internal, organ: organ)
              another_operator
              operator_subnet_internal
              operator_subnet

              sign_out(operator) && sign_in(operator_subnet) && get(:index)

              expect(view_context.users).to match_array([operator_subnet_internal, operator_subnet])
            end

            it 'for sic_sectoral' do
              operator_sectoral_sic = create(:user, :operator_sectoral_sic, organ: organ)
              operator_internal = create(:user, :operator_internal, organ: organ)
              another_operator
              another_operator

              sign_out(operator) && sign_in(operator_sectoral_sic) && get(:index)

              expect(view_context.users).to match_array([operator_sectoral_sic, operator_internal])
            end
          end
        end

        context 'pagination' do
          it 'calls kaminari methods' do
            allow(User).to receive(:page).and_call_original
            expect(User).to receive(:page).and_call_original

            get(:index)

            # para poder chamar o page que estamos testando
            view_context.users
          end
        end

        context 'search' do
          it 'name case insensitive' do
            filtered_user = create(:user, :operator_sectoral, organ: organ, name: 'user filtered')
            another_operator

            get(:index, params: { search: 'filTer' })

            expect(view_context.users).to eq([filtered_user])
          end

          it 'email case sensitive' do
            create(:user, :operator_sectoral, organ: organ, email: 'avoid@example.com')
            filtered_user = create(:user, :operator_sectoral, organ: organ, email: 'filtered@example.com')

            get(:index, params: { search: 'filTered' })

            expect(view_context.users).to eq([filtered_user])
          end
        end

        describe 'sort' do
          it 'sort_columns helper' do
            expected = [
              'users.name',
              'users.email',
              'users.operator_type'
            ]

            expect(view_context.sort_columns).to eq(expected)
          end
        end
      end
    end
  end

  describe '#new' do
    context 'unauthorized' do
      before { get(:new) }

      it { is_expected.to redirect_to(new_user_session_path) }
    end

    context 'authorized' do

      context 'not sectoral' do
        before { sign_in(operator_internal) && get(:new) }

        it { is_expected.to respond_with(:forbidden) }
      end

      context 'sectoral' do
        before { sign_in(operator) && get(:new) }

        context 'template' do
          render_views

          it { is_expected.to respond_with(:success) }
          it { is_expected.to render_template('operator/users/new') }
          it { is_expected.to render_template('operator/users/_form') }
        end

        describe 'helper methods' do
          it 'user' do
            expect(view_context.user).to be_new_record
          end
        end
      end
    end
  end

  describe '#create' do

    let(:valid_user) do
      user = attributes_for(:user, :operator_sectoral)

      user[:email_confirmation] = user[:email]
      user[:organ_id] = operator.organ_id

      user
    end

    let(:invalid_user) do
      user = attributes_for(:user, :operator_sectoral, :invalid)
      user[:organ_id] = operator.organ_id
      user
    end

    let(:created_user) { User.last }

    context 'unauthorized' do
      before { post(:create, params: { user: valid_user }) }

      it { is_expected.to redirect_to(new_user_session_path) }
    end

    context 'authorized' do

      context 'not sectoral' do
        before { sign_in(operator_internal) && post(:create, params: { user: valid_user }) }

        it { is_expected.to respond_with(:forbidden) }
      end

      context 'sectoral' do
        before { sign_in(operator) }

        it 'permits user params' do
          should permit(*permitted_params).
            for(:create, params:  { user: valid_user } ).on(:user)
        end

        context 'valid' do
          it 'saves' do
            expect do
              post(:create, params: { user: valid_user })

              expected_flash = I18n.t('operator.users.create.done',
                title: created_user.title)

              expect(created_user.user_type).to eq('operator')
              expect(created_user.operator_type).to eq(operator.operator_type)

              expect(response).to redirect_to(operator_user_path(created_user))
              expect(controller).to set_flash.to(expected_flash)
            end.to change(User, :count).by(1)
          end

          it 'ensure organ' do
            expect do
              post(:create, params: { user: valid_user })

              expected_flash = I18n.t('operator.users.create.done',
                title: created_user.title)

              expect(created_user.organ_id).to eq(operator.organ_id)

              expect(response).to redirect_to(operator_user_path(created_user))
              expect(controller).to set_flash.to(expected_flash)

            end.to change(User, :count).by(1)
          end

          context 'subnet' do

            let(:operator) { create(:user, :operator_subnet) }

            it 'ensure subnet' do
              expect do
                subnet = operator.subnet
                department = create(:department, subnet: subnet)
                user.update(organ_id: department.organ_id)

                valid_user[:operator_type] = :internal
                valid_user[:department_id] = department.id
                valid_user[:subnet_id] = subnet.id

                post(:create, params: { user: valid_user })

                expected_flash = I18n.t('operator.users.create.done',
                  title: created_user.title)

                expect(created_user.organ_id).to eq(operator.organ_id)
                expect(created_user.subnet_id).to eq(operator.subnet_id)
                expect(created_user).to be_internal_subnet

                expect(response).to redirect_to(operator_user_path(created_user))
                expect(controller).to set_flash.to(expected_flash)

              end.to change(User, :count).by(1)
            end
          end

          it 'sends email with confirmation instructions for created user' do
            expect_any_instance_of(User).to receive(:send_confirmation_instructions).and_return(nil)

            post(:create, params: { user: valid_user })
          end
        end

        context 'invalid' do
          context 'template' do
            render_views

            it 'does not save' do
              expect do
                post(:create, params: { user: invalid_user })

                expected_flash = I18n.t('operator.users.create.error')

                expect(controller).to set_flash.now.to(expected_flash)
                expect(response).to render_template('operator/users/new')
              end.to change(User, :count).by(0)
            end
          end

          context 'permissions' do

            context 'operator_cge' do

              before { sign_in(operator_cge) }

              it 'cannot create cge' do
                organ = create(:executive_organ)
                user = attributes_for(:user, :operator_cge)
                user[:email_confirmation] = user[:email]
                user[:organ_id] = organ.id

                post(:create, params: { user: user })

                is_expected.to respond_with(:forbidden)
              end

              it 'cannot create sectoral' do
                user = attributes_for(:user, :operator_sectoral)
                user[:email_confirmation] = user[:email]
                user[:organ_id] = create(:executive_organ).id

                post(:create, params: { user: user })

                is_expected.to respond_with(:forbidden)
              end

              it 'cannot create chief' do
                organ_id = create(:executive_organ).id
                user = attributes_for(:user, :operator_chief)
                user[:email_confirmation] = user[:email]
                user[:organ_id] = organ_id

                post(:create, params: { user: user })

                is_expected.to respond_with(:forbidden)
              end

              it 'cannot create admin' do
                user = attributes_for(:user, :admin)
                user[:email_confirmation] = user[:email]

                post(:create, params: { user: user })

                is_expected.to respond_with(:forbidden)
              end
            end

            context 'sectoral_sou' do
              let(:operator_sectoral_sou) { create(:user, :operator_sectoral, organ: organ) }

              before { sign_in(operator_sectoral_sou) }

              it 'can create sectoral_sic' do
                user = attributes_for(:user, :operator_sectoral_sic)
                user[:email_confirmation] = user[:email]
                user[:organ_id] = organ.id

                post(:create, params: { user: user })

                is_expected.to respond_with(:found)
                expect(view_context.user.sic_sectoral?).to be_truthy
              end

              it 'can create internal' do
                department = create(:department, organ: organ)
                user = attributes_for(:user, :operator_internal, department_id: department.id)
                user[:email_confirmation] = user[:email]
                user[:organ_id] = organ.id

                post(:create, params: { user: user })

                is_expected.to respond_with(:found)
                expect(view_context.user.internal?).to be_truthy
              end
            end

            context 'sectoral_sic' do
              let(:operator_sectoral_sic) { create(:user, :operator_sectoral_sic, organ: organ) }

              before { sign_in(operator_sectoral_sic) }

              it 'can create sectoral_sic' do
                user = attributes_for(:user, :operator_sectoral_sic, organ: organ)
                user[:email_confirmation] = user[:email]
                user[:organ_id] = organ.id

                post(:create, params: { user: user })

                is_expected.to respond_with(:found)
              end

              it 'cannot create sectoral_sou' do
                user = attributes_for(:user, :operator_sectoral, organ: organ)
                user[:email_confirmation] = user[:email]

                post(:create, params: { user: user })

                is_expected.to respond_with(:forbidden)
              end

              it 'can create internal' do
                department = create(:department, organ: organ)
                user = attributes_for(:user, :operator_internal, department_id: department.id)
                user[:email_confirmation] = user[:email]
                user[:organ_id] = organ.id

                post(:create, params: { user: user })

                is_expected.to respond_with(:found)
              end
            end
          end
        end

        describe 'helper methods' do
          it 'user' do
            expect(view_context.user).to be_new_record
          end
        end
      end
    end
  end

  describe '#show' do
    context 'unauthorized' do
      before { get(:show, params: { id: another_operator }) }

      it { is_expected.to redirect_to(new_user_session_path) }
    end

    context 'authorized' do

      context 'not sectoral' do
        before { sign_in(operator_internal) && get(:show, params: { id: another_operator }) }

        it { is_expected.to respond_with(:forbidden) }
      end

      context 'sectoral' do
        before { sign_in(operator) && get(:show, params: { id: another_operator }) }

        describe 'helper methods' do
          it 'user' do
            expect(view_context.user).to eq(another_operator)
          end
        end
      end
    end
  end

  describe '#edit' do
    context 'unauthorized' do
      before { get(:edit, params: { id: another_operator }) }

      it { is_expected.to redirect_to(new_user_session_path) }
    end

    context 'authorized' do

      context 'sectoral' do
        before { sign_in(operator) && get(:edit, params: { id: other_operator }) }

        it { is_expected.to respond_with(:forbidden) }
      end

      context 'internal' do
        before { sign_in(operator) && get(:edit, params: { id: operator_internal }) }

        context 'template' do
          render_views

          it { is_expected.to respond_with(:success) }
          it { is_expected.to render_template('operator/users/edit') }
          it { is_expected.to render_template('operator/users/_form') }
        end

        describe 'helper methods' do
          it 'user' do
            expect(view_context.user).to eq(operator_internal)
          end
        end
      end
    end
  end

  describe '#update' do
    let(:valid_user) { operator_internal }
    let(:invalid_user) do
      user = create(:user, :operator_internal, organ: organ)
      user.name = nil
      user
    end

    let(:valid_user_attributes) { valid_user.attributes }
    let(:valid_user_params) { { id: valid_user, user: valid_user_attributes } }
    let(:invalid_user_params) do
      { id: invalid_user, user: invalid_user.attributes }
    end

    context 'unauthorized' do
      before { patch(:update, params: valid_user_params) }

      it { is_expected.to redirect_to(new_user_session_path) }
    end

    context 'authorized' do

      context 'sectoral' do
        before { sign_in(operator) }

        it 'permits user params' do
          should permit(*permitted_params).
            for(:update, params: valid_user_params ).on(:user)
        end

        context 'valid' do
          it 'saves' do
            valid_user_params[:user]['name'] = 'new name'
            valid_user_params[:user]['email_confirmation'] = valid_user_params[:user]['email']

            patch(:update, params: valid_user_params)

            expect(response).to redirect_to(operator_user_path(operator_internal))

            valid_user.reload

            expected_flash = I18n.t('operator.users.update.done',
              title: valid_user.title)

            expect(valid_user.name).to eq('new name')
            expect(valid_user.organ_id).to eq(operator.organ_id)

            expect(controller).to set_flash.to(expected_flash)
          end

          context 'subnet' do
            let(:operator) { operator_subnet }
            let(:valid_user) { operator_subnet_internal }

            it 'ensure subnet' do
              expect do
                department = create(:department)

                valid_user_params[:user][:operator_type] = :internal
                valid_user_params[:user][:department_id] = department.id
                valid_user_params[:user][:subnet_id] = operator.subnet_id

                patch(:update, params: valid_user_params)

                created_user = controller.view_context.user

                expect(created_user.organ_id).to eq(operator.organ_id)
                expect(created_user.subnet_id).to eq(operator.subnet_id)
                expect(created_user).to be_internal_subnet
              end.to change(User, :count).by(1)
            end
          end
        end

        context 'itself' do
          let(:valid_user) { operator }

          it 'not allowed params' do
            other_organ = create(:executive_organ)

            valid_user_params[:operator_type] = :sic_sectoral
            valid_user_params[:organ_id] = other_organ.id

            patch(:update, params: valid_user_params)

            valid_user.reload

            expect(valid_user.sic_sectoral?).to be_falsey
            expect(valid_user.organ).to eq(organ)
          end
        end

        context 'invalid' do

          context 'template' do
            render_views

            it 'does not save' do
              patch(:update, params: invalid_user_params)
              expect(response).to render_template('operator/users/edit')
            end
          end

          context 'permissions' do

            context 'operator_cge' do

              before { sign_in(operator_cge) }

              it 'cannot update sectoral' do
                user = create(:user, :operator_sectoral)
                user_params = user.attributes

                patch(:update, params: { id: user.id, user: user_params })

                is_expected.to respond_with(:forbidden)
              end

              it 'cannot update chief' do
                user = create(:user, :operator_chief)
                user_params = user.attributes

                patch(:update, params: { id: user.id, user: user_params })

                is_expected.to respond_with(:forbidden)
              end
            end

            context 'sectoral_sou' do
              let(:operator_sectoral) { create(:user, :operator_sectoral, organ: organ) }

              before { sign_in(operator_sectoral) }

              it 'can update internal' do
                user_params = operator_internal.attributes

                patch(:update, params: { id: operator_internal.id, user: user_params })

                is_expected.to respond_with(:found)
              end

              it 'cannot update sectoral_sic' do
                user = create(:user, :operator_sectoral_sic, organ: organ)
                user_params = user.attributes

                patch(:update, params: { id: user.id, user: user_params })

                is_expected.to respond_with(:forbidden)
              end

              it 'cannot update sectoral_sou' do
                user = create(:user, :operator_sectoral, organ: organ)
                user_params = user.attributes

                patch(:update, params: { id: user.id, user: user_params })

                is_expected.to respond_with(:forbidden)
              end

            end

          end
        end

        describe 'helper methods' do
          it 'user' do
            patch(:update, params: valid_user_params)
            expect(view_context.user).to eq(valid_user)
          end

          context 'yourself?' do

            before { patch(:update, params: valid_user_params) }

            context 'true' do
              let(:valid_user) { operator }

              it { expect(view_context.yourself?).to be_truthy }
            end

            context 'false' do
              it { expect(view_context.yourself?).to be_falsey }
            end
          end
        end
      end
    end
  end

  let(:user) { operator }
  let(:resources) { [user] + create_list(:user, 1, :operator_internal, organ: organ) }
  it_behaves_like 'controllers/base/toggle_disabled'

end
