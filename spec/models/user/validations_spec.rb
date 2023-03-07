require 'rails_helper'

describe User::Validations do

  subject(:user) { build(:user) }

  describe 'validations' do

    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_uniqueness_of(:email).case_insensitive }
    it { is_expected.to validate_presence_of(:user_type) }

    describe '#department' do
      context 'has a sub_department association' do
        before { allow(subject).to receive(:sub_department_id?).and_return(true) }
        it { is_expected.to validate_presence_of(:department) }
      end

      context 'hasnt a organ association' do
        before { allow(subject).to receive(:sub_department_id?).and_return(false) }
        it { is_expected.not_to validate_presence_of(:department) }
      end
    end

    describe '#organ' do
      context 'has a department association' do
        before { allow(subject).to receive(:department_id?).and_return(true) }
        it { is_expected.to validate_presence_of(:organ) }
      end

      context 'hasnt a department association' do
        before { allow(subject).to receive(:department_id?).and_return(false) }
        it { is_expected.not_to validate_presence_of(:organ) }
      end

      context 'has a subnet association' do
        before { allow(subject).to receive(:subnet_id?).and_return(true) }
        it { is_expected.to validate_presence_of(:organ) }
      end

      context 'hasnt a subnet association' do
        before { allow(subject).to receive(:subnet_id?).and_return(false) }
        it { is_expected.not_to validate_presence_of(:organ) }
      end
    end

    describe 'email' do
      context 'allowed' do
        it { is_expected.to allow_value("admin@example.com").for(:email) }
        it { is_expected.to allow_value("admin@example.br").for(:email) }
      end

      context 'denied' do

        # Cusmomizando validação pois esta validação não é barrada pelo devise
        it { is_expected.to_not allow_value("admin@example").for(:email) }

        it { is_expected.to_not allow_value("admin@").for(:email) }
        it { is_expected.to_not allow_value("admin").for(:email) }
        it { is_expected.to_not allow_value("@example").for(:email) }
        it { is_expected.to_not allow_value("@example.com").for(:email) }
        it { is_expected.to_not allow_value("@example.com.br").for(:email) }
      end
    end

    describe 'CPF' do
      subject { build(:user, :cpf) }

      describe 'format' do
        describe 'wrong format' do
          before { subject.document = '12345699999' }
          it { is_expected.to be_invalid }
        end
        describe 'right format' do
          it { is_expected.to be_valid }
        end
      end
    end

    describe 'CNPJ' do
      subject { build(:user, :legal) }

      describe 'format' do
        describe 'wrong format' do
          before { subject.document = '12345699999' }
          it { is_expected.to be_invalid }
        end
        describe 'right format' do
          it { is_expected.to be_valid }
        end
      end
    end

    describe 'admin' do
      subject(:user) { build(:user, :admin) }

      it { is_expected.to validate_presence_of(:person_type) }
      it { is_expected.to validate_presence_of(:document_type) }
      it { is_expected.to validate_presence_of(:document) }
      it { is_expected.not_to validate_presence_of(:city) }
      it { is_expected.not_to validate_presence_of(:state) }
    end

    describe 'operator_type' do
      subject(:user) { build(:user, :operator) }

      it { is_expected.to validate_presence_of(:person_type) }
      it { is_expected.to validate_presence_of(:document_type) }
      it { is_expected.to validate_presence_of(:document) }
      it { is_expected.not_to validate_presence_of(:city) }
      it { is_expected.not_to validate_presence_of(:state) }

      context 'cge' do
        subject(:user) { build(:user, :operator_cge) }

        it { is_expected.to validate_presence_of(:operator_type) }
      end

      context 'sectoral' do
        subject(:user) { build(:user, :operator_sectoral) }

        it { is_expected.to validate_presence_of(:operator_type) }
        it { is_expected.to validate_presence_of(:organ) }
      end

      context 'internal' do
        subject(:user) { build(:user, :operator_internal) }

        it { is_expected.to validate_presence_of(:operator_type) }
        it { is_expected.to validate_presence_of(:department) }
        it { is_expected.not_to validate_presence_of(:city) }
      end

      context 'chief' do
        subject(:user) { build(:user, :operator_chief) }

        it { is_expected.to validate_presence_of(:operator_type) }
        it { is_expected.to validate_presence_of(:organ) }
        it { is_expected.not_to validate_presence_of(:city) }
      end

      context 'subnet_sectoral' do
        subject(:user) { build(:user, :operator_subnet) }

        it { is_expected.to validate_presence_of(:operator_type) }
        it { is_expected.to validate_presence_of(:subnet) }
        it { is_expected.not_to validate_presence_of(:city) }
      end

      context 'subnet_chief' do
        subject(:user) { build(:user, :operator_subnet_chief) }

        it { is_expected.to validate_presence_of(:operator_type) }
        it { is_expected.to validate_presence_of(:subnet) }
        it { is_expected.not_to validate_presence_of(:city) }
      end
    end

    describe 'person_type' do

      context 'individual' do
        subject(:user) { build(:user, :user) }

        it { is_expected.to validate_presence_of(:person_type) }
        it { is_expected.to validate_presence_of(:document_type) }
        it { is_expected.to validate_presence_of(:document) }
        it { is_expected.to validate_presence_of(:city) }

        context 'facebook' do
          subject(:user_facebook) { build(:user, :user_facebook) }

          it { is_expected.to validate_presence_of(:person_type) }
          it { is_expected.not_to validate_presence_of(:document_type) }
          it { is_expected.not_to validate_presence_of(:document) }
          it { is_expected.to_not validate_presence_of(:city) }
          it { is_expected.to_not validate_presence_of(:state) }
        end
      end

      context 'legal' do
        subject(:user) { build(:user, :legal) }

        it { is_expected.to validate_presence_of(:person_type) }

        # tipo cnpj por padrão
        it { is_expected.to_not validate_presence_of(:document_type) }
        it { is_expected.to validate_presence_of(:document) }
        it { is_expected.to validate_presence_of(:city) }
      end

      context 'location' do
        subject(:user) { build(:user) }

        it { is_expected.to validate_presence_of(:state) }
        it { is_expected.to validate_presence_of(:city) }
      end
    end

    describe 'all user types' do
      subject(:user) { build(:user) }

      it { is_expected.to validate_presence_of(:email_confirmation) }
      it { is_expected.to validate_confirmation_of(:email) }

      context 'validates email_confirmation only when email changes' do

        before { user.save }

        let(:same_user) { User.find(user.id) }

        it { expect(same_user).to be_valid }

        it 'with different confirmation' do
          same_user.email_confirmation = "123#{same_user.email}"

          expect(same_user).to be_invalid
        end

        it 'with empty confirmation' do
          same_user.email = "123#{same_user.email}"

          expect(same_user).to be_invalid
        end
      end
    end

    describe '#validate_organ_department_association' do
      context 'with a invalid organ/department association' do
        let(:executive_organ) { create(:executive_organ) }
        let(:department) { create(:department) }
        let(:user) { build(:user, :operator_internal, department: department, organ: executive_organ) }

        it 'return invalid user' do
          expect(user).to be_invalid
        end

        it 'return error message' do
          user.valid?
          expect(user.errors[:department_id]).to eq([
            I18n.t(
            'activerecord.errors.models.user.attributes.department_id.invalid_organ_association'
            )
          ])
        end
      end

      context 'with a valid organ/department association' do
        it 'return a valid user' do
          department = create(:department)
          organ = department.organ
          user = build(:user, :operator_internal, department: department, organ: organ)
          expect(user).to be_valid
        end
      end
    end

    describe '#validate_subnet_department_association' do
      context 'with a invalid subnet/department association' do
        let(:subnet) { create(:subnet) }
        let(:department) { create(:department) }
        let(:user) { build(:user, :operator_internal, organ: subnet.organ, department: department, subnet: subnet) }

        it 'return invalid user' do
          expect(user).to be_invalid
        end

        it 'return error message' do
          user.valid?
          expect(user.errors[:department_id]).to eq([
            I18n.t(
            'activerecord.errors.models.user.attributes.department_id.invalid_subnet_association'
            )
          ])
        end
      end

      context 'with a valid subnet/deparment association' do
        it 'return a valid user' do
          department = create(:department, :with_subnet)
          organ = department.subnet.organ
          user = build(:user, :operator_internal, organ: organ, department: department,
            subnet: department.subnet)
          expect(user).to be_valid
        end
      end
    end

    describe '#validate_deparment_subdepartment_association' do
      context 'with a invalid deparment/subdepartment association' do
        let(:sub_department) { create(:sub_department) }
        let(:department) { create(:department) }
        let(:organ) { sub_department.department.organ }
        let(:user) {
          build(:user, :operator_internal, organ: organ, department: department, sub_department: sub_department)
        }

        it 'return invalid user' do
          expect(user).to be_invalid
        end

        it 'return error message' do
          user.valid?
          expect(user.errors[:sub_department_id]).to eq([
            I18n.t(
              'activerecord.errors.models.user.attributes.sub_department_id.invalid_department_association'
            )
          ])
        end
      end

      context 'with a valid deparment/subdepartment association' do
        it 'return a valid user' do
          sub_department = create(:sub_department)
          department = sub_department.department
          organ = department.organ
          user = build(:user, :operator_internal, organ: organ, department: department,
            sub_department: sub_department)
          expect(user).to be_valid
        end
      end
    end

    describe 'validate coordinator organ' do
      let(:couvi) { create(:executive_organ, :couvi) }
      let(:user_coordinator) { create(:user, 
        :operator_coordination, 
        organ: couvi, 
        denunciation_tracking: false) 
      }
      
      before { 
        couvi
        user_coordinator
        user.operator_type = :coordination 
      }
      
      it 'coordinator valid is always on COUVI organ' do
        expect(user_coordinator).to be_valid 
      end

      it 'coordinator valid is always denunciation_tracking true' do
        expect(user_coordinator.denunciation_tracking).to be(true)
      end
    
      it 'coordinator invalid' do
        couvi #se nao chamar ele n cria o orgão e a validação nao funciona
        expect(user).not_to be_valid 
      end
    end
  end
end
