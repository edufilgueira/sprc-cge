require 'rails_helper'

describe AttendanceEvaluation do

  subject(:attendance_evaluation) { build(:attendance_evaluation, :with_ticket_sou) }

  describe 'factories' do
    before { allow(subject).to receive(:ticket_type).and_return('sic') }

    it { is_expected.to be_valid }
  end

  describe 'db' do
    describe 'columns' do
      it { is_expected.to have_db_column(:average).of_type(:float) }
      it { is_expected.to have_db_column(:clarity).of_type(:integer).with_options(null: true) }
      it { is_expected.to have_db_column(:classification).of_type(:integer).with_options(null: true) }
      it { is_expected.to have_db_column(:comment).of_type(:text) }
      it { is_expected.to have_db_column(:content).of_type(:integer).with_options(null: true) }
      it { is_expected.to have_db_column(:kindness).of_type(:integer).with_options(null: true) }
      it { is_expected.to have_db_column(:quality).of_type(:integer).with_options(null: true) }
      it { is_expected.to have_db_column(:textual_structure).of_type(:integer).with_options(null: true) }
      it { is_expected.to have_db_column(:treatment).of_type(:integer).with_options(null: true) }
      it { is_expected.to have_db_column(:wording).of_type(:integer).with_options(null: true) }

      # Audits
      it { is_expected.to have_db_column(:created_at).of_type(:datetime) }
      it { is_expected.to have_db_column(:created_by_id).of_type(:integer) }
      it { is_expected.to have_db_column(:updated_at).of_type(:datetime) }
      it { is_expected.to have_db_column(:updated_by_id).of_type(:integer) }
    end
  end

  describe 'validations' do
    context 'presence' do
      context 'sic' do
        before { allow(subject).to receive(:ticket_type).and_return('sic') }

        it { is_expected.to validate_presence_of(:clarity) }
        it { is_expected.to validate_presence_of(:content) }
        it { is_expected.to validate_presence_of(:kindness) }
        it { is_expected.to validate_presence_of(:wording) }
      end

      context 'sou' do
        before { allow(subject).to receive(:ticket_type).and_return('sou') }

        it { is_expected.to validate_presence_of(:textual_structure) }
        it { is_expected.to validate_presence_of(:treatment) }
        it { is_expected.to validate_presence_of(:quality) }
        it { is_expected.to validate_presence_of(:classification) }
      end

    end

    context 'range' do
      before { allow(subject).to receive(:ticket_type).and_return('sic') }

      it { is_expected.to validate_inclusion_of(:clarity).in_range(0..10) }
      it { is_expected.to validate_inclusion_of(:content).in_range(0..10) }
      it { is_expected.to validate_inclusion_of(:wording).in_range(0..10) }
      it { is_expected.to validate_inclusion_of(:kindness).in_range(0..10) }
    end
  end

  describe 'associations' do
    before { allow(subject).to receive(:ticket_type).and_return('sou') }

    it { is_expected.to belong_to(:ticket) }
    it { is_expected.to belong_to(:created_by).class_name('User') }
    it { is_expected.to belong_to(:updated_by).class_name('User') }
  end

  describe 'constants' do
    it { expect(AttendanceEvaluation::EVALUATION_WEIGHTS[:clarity]).to eq(2) }
    it { expect(AttendanceEvaluation::EVALUATION_WEIGHTS[:content]).to eq(5) }
    it { expect(AttendanceEvaluation::EVALUATION_WEIGHTS[:wording]).to eq(2) }
    it { expect(AttendanceEvaluation::EVALUATION_WEIGHTS[:kindness]).to eq(1) }
    it { expect(AttendanceEvaluation::EVALUATION_WEIGHTS_SOU[:textual_structure]).to eq(1) }
    it { expect(AttendanceEvaluation::EVALUATION_WEIGHTS_SOU[:treatment]).to eq(2) }
    it { expect(AttendanceEvaluation::EVALUATION_WEIGHTS_SOU[:quality]).to eq(5) }
    it { expect(AttendanceEvaluation::EVALUATION_WEIGHTS_SOU[:classification]).to eq(2) }
  end

  describe 'callbacks' do
    context 'before_save' do
      context 'calculate_average' do
        context 'sic' do
          before { allow(subject).to receive(:ticket_type).and_return('sic') }

          let(:evaluation_weights) {
            {
              clarity: 2,
              content: 5,
              wording: 2,
              kindness: 1
            }
          }
          let(:expected) {
            expected = attendance_evaluation.clarity * evaluation_weights[:clarity] +
                        attendance_evaluation.content * evaluation_weights[:content] +
                        attendance_evaluation.wording * evaluation_weights[:wording] +
                        attendance_evaluation.kindness * evaluation_weights[:kindness]
            expected.to_f / 10

          }
          
          before do
            subject.clarity = 10
            subject.content = 10
            subject.wording = 9
            subject.kindness = 9
            subject.average = nil

            subject.save
          end

          it { is_expected.to callback(:calculate_average).before(:save) }
          it { expect(subject.average).to eq(expected) }

        end

        context 'sou' do
          before { allow(subject).to receive(:ticket_type).and_return('sou') }

          let(:evaluation_weights) {
            {
              textual_structure: 1,
              treatment: 2,
              quality: 5,
              classification: 2
            }
          }

          let(:expected) {
            expected = attendance_evaluation.textual_structure * evaluation_weights[:textual_structure] +
                        attendance_evaluation.treatment * evaluation_weights[:treatment] +
                        attendance_evaluation.quality * evaluation_weights[:quality] +
                        attendance_evaluation.classification * evaluation_weights[:classification]
            expected.to_f / 10
          }

          before do
            subject.textual_structure = 9
            subject.treatment = 9
            subject.quality = 9
            subject.classification = 10
            subject.average = nil
            
            create(:sou_evaluation_sample_detail, ticket_id: subject.ticket_id)

            subject.save
          end

          it { is_expected.to callback(:calculate_average).before(:save) }
          it { expect(subject.average).to eq(expected) }
        end
      end
    end
  end
  
end
