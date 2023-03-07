require 'rails_helper'

describe Attendance do
  it_behaves_like 'models/paranoia'

  subject(:attendance) { build(:attendance) }

  describe 'factories' do
    it { is_expected.to be_valid }

    it { expect(build(:attendance, :invalid)).to be_invalid }
  end

  describe 'db' do
    describe 'columns' do
      it { is_expected.to have_db_column(:service_type).of_type(:integer) }
      it { is_expected.to have_db_column(:protocol).of_type(:integer) }
      it { is_expected.to have_db_column(:description).of_type(:text) }
      it { is_expected.to have_db_column(:answer).of_type(:text) }
      it { is_expected.to have_db_column(:answered).of_type(:boolean).with_options(default: false) }
      it { is_expected.to have_db_column(:ticket_id).of_type(:integer) }
      it { is_expected.to have_db_column(:created_by_id).of_type(:integer) }
      it { is_expected.to have_db_column(:updated_by_id).of_type(:integer) }
      it { is_expected.to have_db_column(:unknown_organ).of_type(:boolean) }

      # Audits

      it { is_expected.to have_db_column(:deleted_at).of_type(:datetime) }
      it { is_expected.to have_db_column(:created_at).of_type(:datetime) }
      it { is_expected.to have_db_column(:updated_at).of_type(:datetime) }
    end

    describe 'indexes' do
      it { is_expected.to have_db_index(:protocol) }
      it { is_expected.to have_db_index(:ticket_id) }
      it { is_expected.to have_db_index(:deleted_at) }
      it { is_expected.to have_db_index(:created_by_id) }
      it { is_expected.to have_db_index(:updated_by_id) }
    end
  end

  describe 'enums' do

    it 'service_type' do
      types = [
        :sou_forward,
        :sic_forward,
        :sic_completed,
        :sou_search,
        :sic_search,
        :prank_call,
        :immediate_hang_up,
        :hang_up,
        :missing_data,
        :no_communication,
        :no_characteristic,
        :noise,
        :technical_problems,
        :incorrect_click,
        :transferred_call
      ]

      is_expected.to define_enum_for(:service_type).with_values(types)
    end
  end

  describe 'validations' do

    it { is_expected.to validate_presence_of(:service_type) }

    describe 'answer' do
      it 'when sic_forward' do
        attendance.service_type = :sic_forward
        expect(attendance).to_not validate_presence_of(:answer)
      end

      it 'when sic_completed' do
        attendance.service_type = :sic_completed
        expect(attendance).to validate_presence_of(:answer)
      end
    end

    context 'description' do
      context 'when sou_forward' do
        before { attendance.service_type = :sou_forward }
        it { is_expected.to validate_presence_of(:description) }

        context 'when ticket denunciation' do
          let(:ticket) { build(:ticket, :denunciation) }

          before { attendance.ticket = ticket }

          # https://github.com/thoughtbot/shoulda-matchers/issues/904
          # it { is_expected.not_to validate_presence_of(:description) }
          it { is_expected.to_not allow_value(nil).for(:description) }
        end
      end

      context 'when sic_forward' do
        before { attendance.service_type = :sic_forward }
        it { is_expected.to validate_presence_of(:description) }
      end

      context 'when sic_completed' do
        before { attendance.service_type = :sic_completed }
        it { is_expected.to validate_presence_of(:description) }
      end

      context 'when sou_search' do
        before { attendance.service_type = :sou_search }
        it { is_expected.not_to validate_presence_of(:description) }
      end

      context 'when sic_search' do
        before { attendance.service_type = :sic_search }
        it { is_expected.not_to validate_presence_of(:description) }
      end

      context 'when prank_call' do
        before { attendance.service_type = :prank_call }
        it { is_expected.not_to validate_presence_of(:description) }
      end

      context 'when immediate_hang_up' do
        before { attendance.service_type = :immediate_hang_up }
        it { is_expected.not_to validate_presence_of(:description) }
      end

      context 'when hang_up' do
        before { attendance.service_type = :hang_up }
        it { is_expected.not_to validate_presence_of(:description) }
      end

      context 'when missing_data' do
        before { attendance.service_type = :missing_data }
        it { is_expected.not_to validate_presence_of(:description) }
      end

      context 'when no_communication' do
        before { attendance.service_type = :no_communication }
        it { is_expected.not_to validate_presence_of(:description) }
      end

      context 'when noise' do
        before { attendance.service_type = :noise }
        it { is_expected.not_to validate_presence_of(:description) }
      end

      context 'when technical_problems' do
        before { attendance.service_type = :technical_problems }
        it { is_expected.not_to validate_presence_of(:description) }
      end

      context 'when incorrect_click' do
        before { attendance.service_type = :incorrect_click }
        it { is_expected.not_to validate_presence_of(:description) }
      end
    end

    context 'attendance_organ_subnets' do
      context 'when unknown_organ == false' do
        before { attendance.unknown_organ = false }

        it { is_expected.to validate_presence_of(:attendance_organ_subnets) }
      end

      context 'when unknown_organ == false' do
        before do
          attendance.unknown_organ = false
          attendance.service_type = :incorrect_click
        end

        it { is_expected.to_not validate_presence_of(:attendance_organ_subnets) }
      end

      context 'when unknown_organ == true' do
        before { attendance.unknown_organ = true }

        it { is_expected.not_to validate_presence_of(:attendance_organ_subnets) }
      end

      context 'when ticket denunciation' do
        let(:ticket_denunciation) { build(:ticket, :denunciation) }
        before do
          attendance.service_type = :sou_forward
          attendance.unknown_organ = false
          attendance.ticket = ticket_denunciation
        end

        it { is_expected.to allow_value([]).for(:attendance_organ_subnets) }
      end
    end
  end


  describe 'associations' do
    it { is_expected.to belong_to(:ticket) }
    it { is_expected.to belong_to(:created_by).class_name('User') }
    it { is_expected.to belong_to(:updated_by).class_name('User') }
    it { is_expected.to have_one(:organ).through(:ticket) }
    it { is_expected.to have_many(:occurrences) }
    it { is_expected.to have_many(:attendance_organ_subnets) }
  end

  describe 'nested' do
    it { is_expected.to accept_nested_attributes_for(:ticket) }
    it { is_expected.to accept_nested_attributes_for(:attendance_organ_subnets).allow_destroy(true) }
  end

  describe 'helpers' do

    it 'confirmed?' do
      attendance = create(:attendance, :with_ticket)

      expect(attendance.confirmed?).to be_falsey
    end

    it 'service_type_str' do
      expected = Attendance.human_attribute_name("service_type.#{attendance.service_type}")
      expect(attendance.service_type_str).to eq(expected)
    end

    context 'reject_ticket?' do

      context 'sou_forward' do
        before { attendance.service_type = :sou_forward }
        it { expect(attendance.reject_ticket?).to be_falsey }
      end

      context 'sic_forward' do
        before { attendance.service_type = :sic_forward }
        it { expect(attendance.reject_ticket?).to be_falsey }
      end

      context 'sic_completed' do
        before { attendance.service_type = :sic_completed }
        it { expect(attendance.reject_ticket?).to be_falsey }
      end
    end

    context 'sou?' do
      context 'sou_forward' do
        before { attendance.service_type = :sou_forward }
        it { expect(attendance.sou?).to be_truthy }
      end

      context 'sic_forward' do
        before { attendance.service_type = :sic_forward }
        it { expect(attendance.sou?).to be_falsey }
      end

      context 'sic_completed' do
        before { attendance.service_type = :sic_completed }
        it { expect(attendance.sou?).to be_falsey }
      end
    end

    context 'sic?' do
      context 'sou_forward' do
        before { attendance.service_type = :sou_forward }
        it { expect(attendance.sic?).to be_falsey }
      end

      context 'sic_forward' do
        before { attendance.service_type = :sic_forward }
        it { expect(attendance.sic?).to be_truthy }
      end

      context 'sic_completed' do
        before { attendance.service_type = :sic_completed }
        it { expect(attendance.sic?).to be_truthy }
      end
    end

    context 'completed?' do
      context 'sou_forward' do
        before { attendance.service_type = :sou_forward }
        it { expect(attendance.completed?).to be_falsey }
      end

      context 'sic_completed' do
        before { attendance.service_type = :sic_completed }
        it { expect(attendance.completed?).to be_truthy }
      end
    end
  end

  describe 'callbacks' do
    context 'before_validation' do
      context 'when attendance.sic_completed' do

        context 'requires at least one organ' do
          let(:attendance) { build(:attendance, service_type: :sic_completed, answer: 'answer', unknown_organ: true) }

          before { attendance.save }

          it { expect(attendance).to be_invalid }
          it { expect(attendance.errors[:attendance_organ_subnets]).to be_present }
        end

        context 'set unknown_subnet = true' do
          let(:attendance) { create(:attendance, answer: 'answer') }
          let(:subnet) { create(:subnet) }
          let(:organ) { subnet.organ }
          let(:attendance_organ_subnet) { create(:attendance_organ_subnet, attendance: attendance, organ: organ, subnet: subnet) }

          before do
            attendance_organ_subnet
            attendance.update(service_type: :sic_completed)
          end

          it { is_expected.to be_valid }
          it { expect(attendance_organ_subnet.reload).to be_unknown_subnet }
        end
      end
    end
  end
end
