require 'rails_helper'

describe Evaluation do

  subject(:evaluation) { build(:evaluation) }

  describe 'factories' do
    it { is_expected.to be_valid }

    it { expect(build(:evaluation, :invalid)).to be_invalid }
  end

  describe 'db' do
    describe 'columns' do
      it { is_expected.to have_db_column(:question_01_a).of_type(:integer) }
      it { is_expected.to have_db_column(:question_01_b).of_type(:integer) }
      it { is_expected.to have_db_column(:question_01_c).of_type(:integer) }
      it { is_expected.to have_db_column(:question_01_d).of_type(:integer) }
      it { is_expected.to have_db_column(:question_02).of_type(:integer) }
      it { is_expected.to have_db_column(:question_03).of_type(:integer) }
      it { is_expected.to have_db_column(:question_04).of_type(:string) }
      it { is_expected.to have_db_column(:question_05).of_type(:string) }

      it { is_expected.to have_db_column(:average).of_type(:float) }
      it { is_expected.to have_db_column(:evaluation_type).of_type(:integer) }
      it { is_expected.to have_db_column(:answer_id).of_type(:integer) }
    end

    describe 'associations' do
      it { is_expected.to belong_to(:answer) }
      it { is_expected.to have_one(:ticket).through(:answer) }
    end
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:question_01_a) }
    it { is_expected.to validate_presence_of(:question_01_b) }
    it { is_expected.to validate_presence_of(:question_01_c) }
    it { is_expected.to validate_presence_of(:question_01_d) }
    it { is_expected.to validate_presence_of(:question_02) }
    it { is_expected.to validate_presence_of(:question_03) }
    # it { is_expected.to validate_presence_of(:question_05) }

    it { is_expected.to validate_uniqueness_of(:answer_id) }

    describe '#validate question_05' do
      context 'evaluation_type is sou' do
        it { is_expected.to validate_presence_of(:question_05) }
      end

      context 'evaluation_type is sic' do
        before { evaluation.evaluation_type = :sic }
        it { is_expected.not_to validate_presence_of(:question_05) }
      end
    end
  end

  describe 'enuns' do
    it 'evaluation_type' do
      expected = [
        :sou,
        :sic,
        :call_center
      ]

      is_expected.to define_enum_for(:evaluation_type).with_values(expected)
    end
  end

  describe 'callback' do
    it 'calculate_average' do
      attributes = {
        question_01_a: 2,
        question_01_b: 3,
        question_01_c: 3,
        question_01_d: 4
      }

      evaluation = create(:evaluation, attributes)
      expected = (2 + 3 + 3 + 4) / 4.0

      expect(evaluation.average).to eq(expected)
    end
  end

end
