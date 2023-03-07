require 'rails_helper'

describe AttendanceResponse do
  it_behaves_like 'models/timestamp'

  subject(:attendance_response) { build(:attendance_response) }

  describe 'factories' do
    it { is_expected.to be_valid }

    it { expect(build(:classification, :invalid)).to be_invalid }
  end

  describe 'db' do
    describe 'columns' do
      it { is_expected.to have_db_column(:ticket_id).of_type(:integer) }
      it { is_expected.to have_db_column(:description).of_type(:text).with_options(null: false) }
      it { is_expected.to have_db_column(:response_type).of_type(:integer).with_options(null: false) }
    end
  end

  describe 'validations' do
    describe 'presence' do
      it { is_expected.to validate_presence_of(:ticket) }
      it { is_expected.to validate_presence_of(:description) }
      it { is_expected.to validate_presence_of(:response_type) }
    end
  end

  describe 'associations' do
    it { is_expected.to belong_to(:ticket) }
  end

  describe 'enums' do
    it 'response_type' do
      response_types = [:failure, :success]

      is_expected.to define_enum_for(:response_type).with_values(response_types)
    end
  end

  describe 'scope' do
    it 'sorted' do
      expect(AttendanceResponse.sorted).to eq(AttendanceResponse.order(:created_at))
    end
  end

  describe 'delegations' do
    it { is_expected.to delegate_method(:title).to(:ticket).with_prefix }
  end
end
