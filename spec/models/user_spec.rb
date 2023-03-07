require 'rails_helper'

describe User do
  it_behaves_like 'models/paranoia'

  subject(:user) { build(:user) }

  describe 'factories' do
    it { is_expected.to be_valid }
    it { is_expected.to be_confirmed } # default

    it { expect(build(:user, :invalid)).to be_invalid }

    context 'confirmed' do
      subject { build :user, :confirmed }
      it { is_expected.to be_confirmed }
    end

    context 'unconfirmed' do
      subject { build :user, :unconfirmed }
      it { is_expected.not_to be_confirmed }
    end

    context 'user' do
      subject { build :user, :user }
      it { is_expected.to be_valid }
      it { is_expected.to be_confirmed }
    end

    context 'admin' do
      subject { build :user, :admin }
      it { is_expected.to be_valid }
      it { is_expected.to be_confirmed }
    end

    context 'operator' do
      subject { build :user, :operator }
      it { is_expected.to be_valid }
      it { is_expected.to be_confirmed }
    end
  end

  describe 'db' do
    describe 'columns' do
      it { is_expected.to have_db_column(:document).of_type(:string) }
      it { is_expected.to have_db_column(:document_type).of_type(:integer) }
      it { is_expected.to have_db_column(:name).of_type(:string) }
      it { is_expected.to have_db_column(:user_type).of_type(:integer) }
      it { is_expected.to have_db_column(:operator_type).of_type(:integer) }
      it { is_expected.to have_db_column(:organ_id).of_type(:integer) }
      it { is_expected.to have_db_column(:department_id).of_type(:integer) }
      it { is_expected.to have_db_column(:sub_department_id).of_type(:integer) }
      it { is_expected.to have_db_column(:subnet_id).of_type(:integer) }
      it { is_expected.to have_db_column(:person_type).of_type(:integer).with_options(default: :individual) }
      it { is_expected.to have_db_column(:social_name).of_type(:string) }
      it { is_expected.to have_db_column(:gender).of_type(:integer) }
      it { is_expected.to have_db_column(:denunciation_tracking).of_type(:boolean).with_options(default: false) }
      it { is_expected.to have_db_column(:education_level).of_type(:integer) }
      it { is_expected.to have_db_column(:birthday).of_type(:date) }
      it { is_expected.to have_db_column(:server).of_type(:boolean).with_options(default: false) }
      it { is_expected.to have_db_column(:facebook_profile_link).of_type(:string) }
      it { is_expected.to have_db_column(:city_id).of_type(:integer) }
      it { is_expected.to have_db_column(:notification_roles).of_type(:string).with_options(default: '{}') }
      it { is_expected.to have_db_column(:disabled_at).of_type(:datetime) }
      it { is_expected.to have_db_column(:positioning).of_type(:boolean).with_options(default: false) }
      it { is_expected.to have_db_column(:acts_as_sic).of_type(:boolean).with_options(default: false) }
      it { is_expected.to have_db_column(:internal_subnet).of_type(:boolean) }
      it { is_expected.to have_db_column(:rede_ouvir).of_type(:boolean).with_options(default: false) }
      it { is_expected.to have_db_column(:sectoral_denunciation).of_type(:boolean).with_options(default: true) }

      it { is_expected.to have_db_column(:created_at).of_type(:datetime) }
      it { is_expected.to have_db_column(:updated_at).of_type(:datetime) }
    end

    describe 'indexes' do
      it { is_expected.to have_db_index(:organ_id) }
      it { is_expected.to have_db_index(:department_id) }
      it { is_expected.to have_db_index(:sub_department_id) }
      it { is_expected.to have_db_index(:subnet_id) }
      it { is_expected.to have_db_index(:operator_type) }
      it { is_expected.to have_db_index(:document_type) }
      it { is_expected.to have_db_index([:email, :deleted_at]) }
      it { is_expected.to have_db_index(:reset_password_token) }
      it { is_expected.to have_db_index(:user_type) }
    end
  end

  describe 'devise' do
    describe 'database_authenticatable' do
      it { is_expected.to have_db_column(:email).of_type(:string) }
      it { is_expected.to have_db_column(:encrypted_password).of_type(:string) }
    end

    describe 'recoverable' do
      it { is_expected.to have_db_column(:reset_password_token).of_type(:string) }
      it { is_expected.to have_db_column(:reset_password_sent_at).of_type(:datetime) }
    end

    describe 'rememberable' do
      it { is_expected.to have_db_column(:remember_created_at).of_type(:datetime) }
    end

    describe 'trackable' do
      it { is_expected.to have_db_column(:sign_in_count).of_type(:integer) }
      it { is_expected.to have_db_column(:current_sign_in_at).of_type(:datetime) }
      it { is_expected.to have_db_column(:last_sign_in_at).of_type(:datetime) }
      it { is_expected.to have_db_column(:current_sign_in_ip).of_type(:inet) }
      it { is_expected.to have_db_column(:last_sign_in_ip).of_type(:inet) }
    end

    describe 'find_for_authentication' do

    it 'override with disabled_at option' do
      allow(User).to receive(:find_first_by_auth_conditions)

      User.find_for_authentication({})

      expect(User).to have_received(:find_first_by_auth_conditions).with({}, disabled_at: nil)
    end

    end
  end

  describe 'attributes' do
    context 'internal_subnet' do
      it 'default false' do
        # be_falsey aceita false ou nil, queremos que seja exatamente false
        expect(user.internal_subnet).to eq(false)
      end
    end
  end

  describe 'enums' do
    it 'user_type' do
      user_types = [:admin, :operator, :user]

      is_expected.to define_enum_for(:user_type).with_values(user_types)
    end

    it 'document_type' do
      document_types = {
        cpf: 0,
        rg: 2,
        cnh: 3,
        ctps: 4,
        passport: 5,
        voter_registration: 6,
        cnpj: 7,
        other: 1,
        registration: 8
      }

      is_expected.to define_enum_for(:document_type).with_values(document_types)
    end

    it 'operator_type' do
      operator_types = {
        cge: 0,
        call_center_supervisor: 1,
        sou_sectoral: 2,
        internal: 3,
        call_center: 4,
        sic_sectoral: 5,
        # sic_internal: 6,
        chief: 7,
        subnet_sectoral: 8,
        subnet_chief: 9,
        coordination: 10,
        security_organ: 11
      }

      is_expected.to define_enum_for(:operator_type).with_values(operator_types)
    end

    it 'person_type' do
      person_types = [:individual, :legal]

      is_expected.to define_enum_for(:person_type).with_values(person_types)
    end

    it 'gender' do
      gender_types = [:not_informed_gender, :female, :male, :other_gender]

      is_expected.to define_enum_for(:gender).with_values(gender_types)
    end

    it 'education_level' do
      education_levels = {
        # :incomplete_primary_school,
        primary_school: 1,
        # :imcomplete_high_school,
        high_school: 3,
        # :imcomplete_bachelors_degree,
        bachelors_degree: 5,
        # :imcomplete_postgraduate,
        postgraduate: 7
      }

      is_expected.to define_enum_for(:education_level).with_values(education_levels)
    end

  end

  describe 'serializations' do
    # https://github.com/thoughtbot/shoulda-matchers/issues/913
    # it { is_expected.to serialize(:filters) }
    #
    it { expect(user.notification_roles).to be_a Hash }
  end

  describe 'associations' do
    it { is_expected.to have_many(:authentication_tokens) }
    it { is_expected.to have_many(:tickets).with_foreign_key(:created_by_id).dependent(:destroy) }
    it { is_expected.to have_many(:call_center_tickets).with_foreign_key(:call_center_responsible_id) }
    it { is_expected.to belong_to(:organ) }
    it { is_expected.to belong_to(:department) }
    it { is_expected.to belong_to(:sub_department) }
    it { is_expected.to belong_to(:subnet) }
    it { is_expected.to have_many(:gross_exports).dependent(:destroy) }
    it { is_expected.to have_many(:ticket_reports).dependent(:destroy) }
    it { is_expected.to have_many(:solvability_reports).dependent(:destroy) }
    it { is_expected.to have_many(:evaluation_exports).dependent(:destroy) }
    it { is_expected.to belong_to(:city) }
    it { is_expected.to have_one(:state).through(:city) }
    it { is_expected.to have_many(:answer_templates).dependent(:destroy) }

    # PPA
    it { is_expected.to have_many(:ppa_proposals) }
    it { is_expected.to have_many(:ppa_likes).dependent(:destroy) }
    it { is_expected.to have_many(:ppa_dislikes).dependent(:destroy) }
    it { is_expected.to have_many(:ppa_votes).dependent(:destroy) }
    # PPA
  end

  describe 'delegations' do
    it { is_expected.to delegate_method(:name).to(:organ).with_arguments(allow_nil: true).with_prefix }
    it { is_expected.to delegate_method(:acronym).to(:organ).with_arguments(allow_nil: true).with_prefix }
    it { is_expected.to delegate_method(:subnet?).to(:organ).with_arguments(allow_nil: true).with_prefix }
    it { is_expected.to delegate_method(:name).to(:subnet).with_arguments(allow_nil: true).with_prefix }
    it { is_expected.to delegate_method(:acronym).to(:subnet).with_arguments(allow_nil: true).with_prefix }
    it { is_expected.to delegate_method(:full_acronym).to(:subnet).with_arguments(allow_nil: true).with_prefix }

    it { is_expected.to delegate_method(:name).to(:department).with_arguments(allow_nil: true).with_prefix }
    it { is_expected.to delegate_method(:acronym).to(:department).with_arguments(allow_nil: true).with_prefix }
    it { is_expected.to delegate_method(:name).to(:sub_department).with_arguments(allow_nil: true).with_prefix }
    it { is_expected.to delegate_method(:acronym).to(:sub_department).with_arguments(allow_nil: true).with_prefix }
    it { is_expected.to delegate_method(:organ_acronym).to(:department).with_arguments(allow_nil: true).with_prefix }
    it { is_expected.to delegate_method(:organ).to(:department).with_arguments(allow_nil: true).with_prefix }

    it { is_expected.to delegate_method(:name).to(:city).with_prefix }
    it { is_expected.to delegate_method(:title).to(:city).with_prefix }
    it { is_expected.to delegate_method(:state_acronym).to(:city).with_prefix }
    it { is_expected.to delegate_method(:id).to(:state).with_prefix }
  end

  describe 'validations' do
    # spec/models/user/validations_spec.rb
  end

  describe 'callbacks' do
    describe '#set_operator_cge' do
      context 'when denunciation_tracking is true' do
        it 'user_type is defined with operator' do
          user = create(:user, :admin, denunciation_tracking: true)
          expect(user.operator?).to be_truthy
        end

        it 'operator_type is defined with cge' do
          user = create(:user, :admin, denunciation_tracking: true)
          expect(user.cge?).to be_truthy
        end

        it 'organ is defined with nil' do
          rede_ouvir = create(:rede_ouvir_organ)
          user = create(:user, :admin, denunciation_tracking: true, organ: rede_ouvir)
          expect(user.organ_id).to be_nil
        end

        it 'department is defined with nil' do
          department = create(:department)
          user = create(
              :user, :admin, denunciation_tracking: true,
              department: department, organ: department.organ
          )
          expect(user.department_id).to be_nil
        end

        it 'sub_department is defined with nil' do
          sub_department = create(:sub_department)
          user = create(
            :user, :admin, denunciation_tracking: true,
            department: sub_department.department,
            organ: sub_department.department.organ,
            sub_department: sub_department
          )

          expect(user.sub_department_id).to be_nil
        end
      end
    end

    describe '#set_nil_to_organ' do
      ['cge', 'call_center', 'call_center_supervisor'].each do |operator_type|
        context "when user_type is operator and operator_type is #{operator_type}" do
          it 'organ is defined with nil' do
            organ = create(:organ)
            user = create(:user, :operator, operator_type: operator_type, organ: organ)
            expect(user.organ_id).to be_nil
          end

          it 'department is defined with nil' do
            department = create(:department)
            user = create(
                :user, :operator, operator_type: operator_type,
                department: department, organ: department.organ
            )
            expect(user.department_id).to be_nil
          end

          it 'sub_department is defined with nil' do
            sub_department = create(:sub_department)
            user = create(
              :user, :operator, operator_type: operator_type,
              department: sub_department.department,
              organ: sub_department.department.organ,
              sub_department: sub_department
            )

            expect(user.sub_department_id).to be_nil
          end
        end
      end
    end

    describe '#set_nil_to_department' do
      ['chief', 'sou_sectoral', 'sic_sectoral', 'coordination'].each do |operator_type|
        context "when user_type is operator and operator_type is #{operator_type}" do
          it 'organ is not defined with nil' do
            organ = operator_type == 'coordination' ? create(:executive_organ, :couvi) : create(:organ)
            user = create(:user, :operator, operator_type: operator_type, organ: organ)
            expect(user.organ_id).not_to be_nil
          end

          it 'department is defined with nil' do
            organ = operator_type == 'coordination' ? create(:executive_organ, :couvi) : create(:organ)
            department = create(:department, organ: organ)
            user = create(
                :user, :operator, operator_type: operator_type,
                department: department, organ: department.organ
            )
            expect(user.department_id).to be_nil
          end

          it 'sub_department is defined with nil' do
            organ = operator_type == 'coordination' ? create(:executive_organ, :couvi) : create(:organ)
            department = create(:department, organ: organ)
            sub_department = create(:sub_department, department: department)
            user = create(
              :user, :operator, operator_type: operator_type,
              department: sub_department.department,
              organ: sub_department.department.organ,
              sub_department: sub_department
            )

            expect(user.sub_department_id).to be_nil
          end
        end
      end

      ['subnet_sectoral', 'subnet_chief'].each do |operator_type|
        context "when user_type is operator and operator_type is #{operator_type}" do
          it 'organ is not defined with nil' do
            subnet = create(:subnet)
            user = create(
              :user, :operator, operator_type: operator_type, organ: subnet.organ, subnet: subnet
            )
            expect(user.organ_id).not_to be_nil
          end

          it 'department is defined with nil' do
            subnet = create(:subnet)
            department = create(:department)

            user = create(
                :user, :operator, operator_type: operator_type,
                organ: subnet.organ, subnet: subnet, department: department
            )
            expect(user.department_id).to be_nil
          end

          it 'sub_department is defined with nil' do
            subnet = create(:subnet)
            sub_department = create(:sub_department)
            user = create(
              :user, :operator, operator_type: operator_type,
              organ: subnet.organ, subnet: subnet, sub_department: sub_department
            )

            expect(user.sub_department_id).to be_nil
          end
        end
      end
    end

    describe '#set_nil_to_subnet' do
      ['subnet_chief', 'subnet_sectoral'].each do |operator_type|
        context "when #{operator_type}" do
          it 'subnet is not defined with nil' do
            subnet = create(:subnet)
            user = create(
              :user, :operator, operator_type: operator_type, organ: subnet.organ, subnet: subnet
            )
            expect(user.subnet_id).not_to be_nil
          end
        end
      end

      ['cge', 'call_center', 'call_center_supervisor', 'chief', 'sou_sectoral', 'sic_sectoral'].each do |operator_type|
        context "when #{operator_type}" do
          it 'subnet is defined with nil' do
            subnet = create(:subnet)
            user = create(
              :user, :operator, operator_type: operator_type, organ: subnet.organ, subnet: subnet
            )
            expect(user.subnet_id).to be_nil
          end
        end
      end
    end

    it 'ensure_rede_ouvir_or_executive' do
      rede_ouvir = create(:rede_ouvir_organ)
      user_rede_ouvir = create(:user, :operator_sou_sectoral, organ: rede_ouvir)
      user = create(:user, :operator_sou_sectoral)

      expect(user.rede_ouvir?).to eq(false)
      expect(user_rede_ouvir.rede_ouvir?).to eq(true)
    end

    it 'ensure acts_as_sic available only for sou_sectoral' do
      sou_sectoral = create(:user, :operator_sou_sectoral, acts_as_sic: true)
      other = create(:user, :operator, acts_as_sic: true)


      expect(sou_sectoral).to be_acts_as_sic
      expect(other).not_to be_acts_as_sic
    end

    describe '#set_nil_to_operator_type' do
      context 'when user_type was operator and change to admin' do
        it 'set nil to operator_type' do
          user_operator = create(:user, :operator)
          user_operator.update(user_type: :admin)

          expect(user_operator.operator_type).to be_nil
        end
      end
    end
  end

  describe 'helpers' do

    context 'title' do
      it 'without social name' do
        user.social_name = ""

        expect(user.title).to eq(user.name)
      end

      it 'with social name' do
        user.social_name = "Social name"

        expect(user.title).to eq(user.social_name)
      end
    end

    describe 'operator_type_str' do
      it 'present' do
        user.operator_type = :cge

        expected = I18n.t("user.operator_types.#{user.operator_type}")
        expect(user.operator_type_str).to eq(expected)
      end

      it 'denunciation_tracking' do
        user.operator_type = :cge
        user.denunciation_tracking = true

        expected = I18n.t("user.operator_types.cge_denunciation_tracking")
        expect(user.operator_type_str).to eq(expected)
      end

      it 'nil' do
        user.operator_type = nil

        expect(user.operator_type_str).to eq("")
      end
    end

    it 'document_type_str' do
      user.document_type = :rg
      expected = I18n.t("user.document_types.rg")
      expect(user.document_type_str).to eq(expected)
    end

    context 'gender_str' do
      it 'when nil' do
        user.gender = nil
        expect(user.gender_str).to eq('')
      end

      it 'when present' do

        expected = I18n.t("user.genders.#{user.gender}")
        expect(user.gender_str).to eq(expected)
      end
    end

    it 'education_level_str' do
      expected = I18n.t("user.education_levels.#{user.education_level}")
      expect(user.education_level_str).to eq(expected)
    end

    describe 'sou_operator?' do
      let(:user) { build(:user, :operator_sectoral) }

      it { expect(user.sou_operator?).to be_truthy }

    end

    describe 'sic_operator?' do
      let(:user) { build(:user, :operator_sectoral) }
      before { user.operator_type = :sic_sectoral }

      it { expect(user.sic_operator?).to be_truthy }
    end

    describe 'call_center_operator?' do
      let(:operator_call_center) { build(:user, :operator_call_center) }
      let(:supervisor_call_center) { build(:user, :operator_call_center_supervisor) }

      it { expect(operator_call_center.call_center_operator?).to be_truthy }
      it { expect(supervisor_call_center.call_center_operator?).to be_truthy }
    end

    describe 'operator_chief?' do
      let(:user_chief) { build(:user, :operator_chief) }
      let(:user_subnet_chief) { build(:user, :operator_subnet_chief) }

      it { expect(user_chief.operator_chief?).to be_truthy }
      it { expect(user_subnet_chief.operator_chief?).to be_truthy }
    end

    describe 'sectoral_or_internal?' do

      it 'sectoral' do
        user = build(:user, :operator_sectoral)
        expect(user.sectoral_or_internal?).to be_truthy
      end

      it 'internal' do
        user = build(:user, :operator_internal)
        expect(user.sectoral_or_internal?).to be_truthy
      end

      it 'cge' do
        user = build(:user, :operator_cge)
        expect(user.sectoral_or_internal?).to be_falsey
      end

      it 'call_center' do
        user = build(:user, :operator_call_center)
        expect(user.sectoral_or_internal?).to be_falsey
      end

    end

    describe 'subnet_internal?' do
      it 'internal subnet' do
        internal = build(:user, :operator_subnet_internal)
        expect(internal.subnet_internal?).to be_truthy
      end

      it 'internal' do
        internal = build(:user, :operator_internal)
        expect(internal.subnet_internal?).to be_falsey
      end
    end

    describe 'operator_cge_or_sectoral_or_chief_or_coordination?' do

      it 'cge' do
        cge = build(:user, :operator_cge)
        expect(cge.operator_cge_or_sectoral_or_chief_or_coordination?).to be_truthy
      end

      it 'sectoral' do
        sectoral = build(:user, :operator_sectoral)
        expect(sectoral.operator_cge_or_sectoral_or_chief_or_coordination?).to be_truthy
      end

      it 'chief' do
        chief = build(:user, :operator_chief)
        expect(chief.operator_cge_or_sectoral_or_chief_or_coordination?).to be_truthy
      end

      it 'internal' do
        internal = build(:user, :operator_internal)
        expect(internal.operator_cge_or_sectoral_or_chief_or_coordination?).to be_falsey
      end

      it 'denunciation_tracking' do
        denunciation = build(:user, :operator_cge_denunciation_tracking)
        expect(denunciation.operator_cge_or_sectoral_or_chief_or_coordination?).to be_truthy
      end

      it 'coordination' do
        coordination = build(:user, :operator_coordination)
        expect(coordination.operator_cge_or_sectoral_or_chief_or_coordination?).to be_truthy
      end

    end

    describe 'operator_subnet_or_sectoral_or_chief_or_coordination?' do

      it 'cge' do
        cge = build(:user, :operator_cge)
        expect(cge.operator_subnet_or_sectoral_or_chief_or_coordination?).to be_falsey
      end

      it 'sectoral' do
        sectoral = build(:user, :operator_sectoral)
        expect(sectoral.operator_subnet_or_sectoral_or_chief_or_coordination?).to be_truthy
      end

      it 'chief' do
        chief = build(:user, :operator_chief)
        expect(chief.operator_subnet_or_sectoral_or_chief_or_coordination?).to be_truthy
      end

      it 'subnet chief' do
        chief = build(:user, :operator_subnet_chief)
        expect(chief.operator_subnet_or_sectoral_or_chief_or_coordination?).to be_truthy
      end

      it 'internal' do
        internal = build(:user, :operator_internal)
        expect(internal.operator_subnet_or_sectoral_or_chief_or_coordination?).to be_falsey
      end

      it 'subnet' do
        subnet = build(:user, :operator_subnet)
        expect(subnet.operator_subnet_or_sectoral_or_chief_or_coordination?).to be_truthy
      end

      it 'coordination' do
        coordination = build(:user, :operator_coordination)
        expect(coordination.operator_subnet_or_sectoral_or_chief_or_coordination?).to be_truthy
      end

    end

    describe '#ombudsman' do
      it 'sou sectoral' do
        subnet = build(:user, :operator_sou_sectoral)

        expect(subnet.ombudsman?).to be_truthy
      end

      it 'sic sectoral' do
        subnet = build(:user, :operator_sic_sectoral)

        expect(subnet.ombudsman?).to be_truthy
      end

      it 'subnet sectoral' do
        subnet = build(:user, :operator_subnet)

        expect(subnet.ombudsman?).to be_truthy
      end

      it 'chief' do
        subnet = build(:user, :operator_chief)

        expect(subnet.ombudsman?).to be_falsey
      end

      it 'cge' do
        subnet = build(:user, :operator_cge)

        expect(subnet.ombudsman?).to be_falsey
      end

      it 'coordination' do
        subnet = build(:user, :operator_coordination)

        expect(subnet.ombudsman?).to be_falsey
      end
    end

    context 'namespace' do

      it 'user' do
        user.user_type = :user

        expect(user.namespace).to eq(:platform)
      end

      it 'operator' do
        user.user_type = :operator

        expect(user.namespace).to eq(:operator)
      end

      it 'admin' do
        user.user_type = :admin

        expect(user.namespace).to eq(:admin)
      end
    end

    describe 'self.new_with_session' do
      let(:session) do
        {
          'devise.facebook_data' => {
            'extra' => {
              'raw_info' => {
                'email' => 'example@example',
                'name' => 'Example'
              }
            }
          }
        }
      end
      let(:user) { User.new_with_session({}, session) }

      it { expect(user.name).to eq('Example') }
      it { expect(user.email).to eq('example@example') }
    end

    describe 'user_facebook?' do
      let(:user) { build(:user, :user) }
      let(:user_facebook) { build(:user, :user_facebook) }

      it { expect(user.user_facebook?).to be_falsey }
      it { expect(user_facebook.user_facebook?).to be_truthy }
    end

    context 'organ_or_department_organ_acronym' do
      let(:organ) { create(:executive_organ) }
      let(:department) { create(:department) }

      it 'organ' do
        user.organ = organ
        user.department = nil

        expect(user.organ_or_department_organ_acronym).to eq(organ.acronym)
      end

      it 'organ_and_department' do
        user.organ = nil
        user.department = department

        expected = "#{department.organ_acronym} - #{department.acronym}"
        expect(user.organ_or_department_organ_acronym).to eq(expected)
      end

      it 'organ_and_subnet' do
        subnet = create(:subnet)

        user.organ = subnet.organ
        user.department = nil
        user.subnet = subnet

        expected = "#{subnet.organ_acronym} - #{subnet.acronym}"
        expect(user.organ_or_department_organ_acronym).to eq(expected)
      end

      it 'organ_subnet_and_department' do
        subnet = create(:subnet)
        department = create(:department, subnet: subnet)

        user.organ = subnet.organ
        user.department = department
        user.subnet = subnet

        expected = "#{subnet.organ_acronym} - #{subnet.acronym} - #{department.acronym}"
        expect(user.organ_or_department_organ_acronym).to eq(expected)
      end

      it 'operator_rede_ouvir?' do
        rede_ouvir = create(:rede_ouvir_organ)
        another_organ = create(:executive_organ)

        user = create(:user, :operator_sou_sectoral, organ: rede_ouvir)

        another_sectorial = create(:user, :operator_sou_sectoral, organ: another_organ)
        expect(another_sectorial.organ).not_to be_rede_ouvir_organ

        expect(user.sectoral_rede_ouvir?).to eq(true)
        expect(another_sectorial.sectoral_rede_ouvir?).to eq(false)
      end
    end


    describe '#as_author' do
      subject { user.as_author }

      context 'when user is an admin' do
        let(:user) { create :user, :admin }

        # User#title é um helper que tenta #social_name ou #name
        it { is_expected.to include(user.user_type_str).and include(user.title) }
      end

      context 'when user is a citizen' do
        let(:user) { create :user, :citizen }

        # User#title é um helper que tenta #social_name ou #name
        it { is_expected.to eq user.title }
      end

      context 'when user is operator' do
        context 'and #cge?' do
          let(:user) { create :user, :operator_cge }

          it { is_expected.to include(user.operator_type_str).and include(user.title) }
        end

        context 'and #call_center_supervisor?' do
          let(:user) { create :user, :operator_call_center_supervisor }

          it { is_expected.to include(user.operator_type_str).and include(user.title) }
        end

        context 'and #call_center?' do
          let(:user) { create :user, :operator_call_center }

          it { is_expected.to include(user.operator_type_str).and include(user.title) }
        end

        context 'and #internal subnet?' do
          let(:user) { create :user, :operator_subnet_internal }

          it do
            is_expected.to include(user.operator_type_str)
              .and include(user.title)
              .and include(user.organ_acronym)
              .and include(user.subnet_acronym)
              .and include(user.department_acronym)
          end
        end

        # XXX os demais tipos possíveis de operadores, exceto os especiais descritos acima.
        # Lista criada por análise da factory `factoreis/users.rb`
        %i[
          operator_sectoral
          operator_sectoral_sic
          operator_internal
          operator_chief
          operator_subnet
          operator_coordination
        ].each do |operator_type_trait|
          context "when user is #{operator_type_trait}" do
            let(:user) { create :user, operator_type_trait }

            it do
              is_expected.to include(user.organ_or_department_organ_acronym)
                .and include(user.operator_type_str)
                .and include(user.title)
            end
          end
        end
      end
    end # #operator_description
  end

  describe '#operator_denunciation?' do
    context 'when user have denunciation tracking permission' do
      context 'when user is cge' do
        it 'return true' do
          user = create(:user, :operator_cge_denunciation_tracking)
          expect(user.operator_denunciation?).to be_truthy
        end
      end

      context 'when user is coordination' do
        it 'return true' do
          user = create(:user, :operator_coordination)
          expect(user.operator_denunciation?).to be_truthy
        end
      end
` `
      context 'when user isnt coordination' do
        it 'return true' do
          user = create(:user, :operator_sectoral)
          expect(user.operator_denunciation?).to be_falsey
        end
      end
    end

    context 'when user havent denunciation tracking permission' do
      it 'return false' do
        user = create(:user, :operator, denunciation_tracking: false)
        expect(user.operator_denunciation?).to be_falsey
      end
    end
  end

  describe '#permission_to_answer?' do
    let(:ticket) { build(:ticket) }

    context 'when user is coordination' do
      it 'return true' do
        user = create(:user, :operator_coordination)
        ticket.organ_id = user.organ_id

        expect(user.permission_to_answer?(ticket)).to be_truthy
      end
    end

    context 'when user is cge' do
      it 'return true' do
        user = create(:user, :operator_cge)
        ticket.organ_id = user.organ_id

        expect(user.permission_to_answer?(ticket)).to be_truthy
      end
    end

    context 'when user is sectoral' do
      let(:user) { create(:user, :operator_sectoral) }

      context 'when user organ equal ticket organ' do
        it 'return true' do
          ticket.organ_id = user.organ_id
          expect(user.permission_to_answer?(ticket)).to be_truthy
        end
      end

      context 'when user organ is different than ticket organ' do
        it 'return false' do
          ticket.organ_id = user.organ_id + 1
          expect(user.permission_to_answer?(ticket)).to be_falsey
        end
      end
    end

    context 'when user is subnet_sectoral' do
      let(:user) { create(:user, :operator_subnet_sectoral) }

      context 'when user subnet equal ticket subnet' do
        it 'return true' do
          ticket.subnet_id = user.subnet_id
          expect(user.permission_to_answer?(ticket)).to be_truthy
        end
      end

      context 'when user subnet is different than ticket subnet' do
        it 'return false' do
          ticket.subnet_id = user.subnet_id + 1
          expect(user.permission_to_answer?(ticket)).to be_falsey
        end
      end
    end
  end

  describe '#permission_to_show_organs_on_reports?' do
    context 'when user is coordination' do
      it 'return true' do
        user = create(:user, :operator_coordination)
        expect(user.permission_to_show_organs_on_reports?).to be_truthy
      end
    end

    context 'when user is cge' do
      it 'return true' do
        user = create(:user, :operator_cge)
        expect(user.permission_to_show_organs_on_reports?).to be_truthy
      end
    end

    context 'when user is sectoral' do
      it 'return true' do
        user = create(:user, :operator_sectoral)
        expect(user.permission_to_show_organs_on_reports?).to be_falsey
      end
    end

    context 'when user is operator call center' do
      it 'return true' do
        user = create(:user, :operator_call_center)
        expect(user.permission_to_show_organs_on_reports?).to be_truthy
      end
    end
  end

  it_behaves_like 'models/disableable'
end