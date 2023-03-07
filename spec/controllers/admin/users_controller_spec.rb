require 'rails_helper'

describe Admin::UsersController do
  let(:user) { create(:user, :admin) }

  let(:resources) { [user] + create_list(:user, 1, :operator) }

  let(:permitted_params) do
    [
      :name,
      :social_name,
      :gender,
      :document,
      :document_type,
      :email,
      :email_confirmation,
      :user_type,
      :operator_type,
      :organ_id,
      :department_id,
      :sub_department_id,
      :subnet_id,
      :password,
      :password_confirmation,
      :person_type,
      :internal_subnet,
      :denunciation_tracking,
      :education_level,
      :birthday,
      :server,
      :city_id,
      :positioning,
      :acts_as_sic,
      :sectoral_denunciation,
      notification_roles: User::NOTIFICATION_ROLES
    ]
  end

  let(:valid_params) do
    user = build(:user).attributes
    user[:email_confirmation] = user['email']
    user[:password] = 'Ab@123456'
    user[:password_confirmation] = user[:password]

    { user: user }
  end


  let(:invalid_passwords) do
    [
      'abc',
      'abdcefghijlm',
      '123456',
      '12345678',
      'abc1234567',
      'ABC1234567!@#$%',
      'asdfgh12345!@#$%#$'
    ]
  end

  let(:valid_passwords) do
    [
      'abAB123!@#',
      'qwerT123!@#',
      'Aa!45678'
    ]
  end

  it_behaves_like 'controllers/admin/base/index' do

    it_behaves_like 'controllers/admin/base/index/xhr'
    it_behaves_like 'controllers/base/index/paginated'
    it_behaves_like 'controllers/base/index/search'
    it_behaves_like 'controllers/admin/base/index/filter_disabled' do
      let(:resource) { create(:user, :admin) }
      let(:resource_disabled) { create(:user, :admin, disabled_at: DateTime.now) }
    end

    it_behaves_like 'controllers/base/index/sorted' do
      let(:sort_columns) do
        {
          name: 'users.name',
          email: 'users.email',
          user_type: 'users.user_type',
          operator_type: 'users.operator_type',
          organ: 'organs.acronym'
        }
      end

      let(:first_unsorted) do
        create(:user, :operator, name: '456', organ: create(:executive_organ, acronym: '123'))
      end

      let(:last_unsorted) do
        create(:user, :operator, name: '123', organ: create(:executive_organ, acronym: '456'))
      end
    end

    context 'filters' do
      it 'user_type' do
        user
        resources.first

        get(:index, params: { user_type: :admin })

        expect(controller.users).to eq([user])
      end

      it 'operator_type' do
        operator_cge = create(:user, :operator_cge)
        operator_internal = create(:user, :operator_internal)

        get(:index, params: { user_type: :operator, operator_type: :cge })

        expect(controller.users).to eq([operator_cge])
      end

      it 'person_type' do
        user_individual = create(:user, :operator, :individual)
        user_legal = create(:user, :operator, :legal)

        get(:index, params: { person_type: :individual })

        expect(controller.users).to eq([user_individual])
      end

      it 'denunciation_tracking' do
        user_denunciation = create(:user, :operator_cge_denunciation_tracking)
        user

        get(:index, params: { denunciation_tracking: true })

        expect(controller.users).to eq([user_denunciation])
      end

      it 'rede ouvir' do
        user_rede_ouvir = create(:user, :rede_ouvir)
        user

        get(:index, params: { rede_ouvir: true })

        expect(controller.users).to eq([user_rede_ouvir])
      end
    end

    context 'scope' do

      let(:operator) { create(:user, :operator) }
      let(:citizen) { create(:user, :user) }

      it 'only administrative users' do
        user
        operator
        citizen

        expect(controller.users).to match_array([user, operator])
      end
    end
  end

  it_behaves_like 'controllers/admin/base/new'

  it_behaves_like 'controllers/admin/base/create' do
    context 'before_validation' do
      before { sign_in(user) }

      it 'saves cnpj' do
        valid_params[:user]['person_type'] = :legal
        post(:create, params: valid_params)

        expect(controller.user.document_type).to eq('cnpj')
      end

      it 'does not save cnpj' do
        post(:create, params: valid_params)

        expect(controller.user.document_type).to eq('other')
      end
    end
  end


  describe '#create' do
    before { sign_in user }

    let(:params) { valid_params }

    subject(:post_create) { post :create, params: params }

    context 'when no password is supplied' do
      before do
        params[:user].delete(:password)
        params[:user].delete(:password_confirmation)
      end

      it "creates an user with a random hash password (since confirmation is required)" do
        expect { post_create }.to change { User.count }.by(1)

        created_user = User.last
        expect(created_user).not_to be_confirmed
        expect(created_user.encrypted_password).to be_present
      end
    end

    context 'when password is supplied' do
      it "creates an user with the supplied password" do
        expect { post_create }.to change { User.count }.by(1)

        created_user = User.last
        expect(created_user).not_to be_confirmed
        expect(created_user.valid_password?(params.dig(:user, :password))).to be true
      end
    end
  end

  describe '#update' do
    context 'when user_type updated to admin' do
      it 'operator_type is set nil' do
        sign_in(user)

        user_operator = create(:user, :operator)
        result = put(:update, params: { user: { user_type: :admin }, id: user_operator.id })
        user_operator.reload

        expect(user_operator.operator_type).to be_nil
      end
    end

    context 'change new password' do
      it 'with invalid password' do
        sign_in(user)
        for pwd in invalid_passwords
          complexity_msg = I18n.t('activerecord.errors.models.user.attributes.password.password_complexity')

          result = put(:update, params: { user: { password: pwd, password_confirmation: pwd }, id: user.id })
          error_password =  controller.user.errors.messages[:password]

          is_expected.to respond_with(:success)
          expect(error_password.include? complexity_msg).to be true
        end
      end
      it 'with valid password' do
        sign_in(user)
        for pwd in valid_passwords
          complexity_msg = I18n.t('activerecord.errors.models.user.attributes.password.password_complexity')

          result = put(:update, params: { user: { password: pwd, password_confirmation: pwd }, id: user.id })
          is_expected.to respond_with(:redirect)
        end
      end
    end
  end

  it_behaves_like 'controllers/admin/base/show'

  it_behaves_like 'controllers/admin/base/edit'

  it_behaves_like 'controllers/admin/base/update' do
    context 'before_validation' do
      before { sign_in(user) }

      it 'saves cnpj' do
        valid_params[:user]['person_type'] = :legal
        patch(:update, params: valid_params.merge({id: resources.first.id}))

        expect(controller.user.document_type).to eq('cnpj')
      end

      it 'does not save cnpj' do
        patch(:update, params: valid_params.merge({id: resources.first.id}))

        expect(controller.user.document_type).to eq('other')
      end
    end
  end

  it_behaves_like 'controllers/admin/base/toggle_disabled'
end
