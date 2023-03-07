require 'rails_helper'

describe Transparency::SurveyAnswer do
  subject(:transparency_survey_answer) { create(:transparency_survey_answer) }

  describe 'factories' do
    it { is_expected.to be_valid }
  end

  describe 'db' do
    describe 'columns' do
      it { is_expected.to have_db_column(:transparency_page).of_type(:string) }
      it { is_expected.to have_db_column(:answer).of_type(:integer) }
      it { is_expected.to have_db_column(:date).of_type(:date) }
      it { is_expected.to have_db_column(:email).of_type(:string) }
      it { is_expected.to have_db_column(:message).of_type(:text) }

      it { is_expected.to have_db_column(:controller).of_type(:string) }
      it { is_expected.to have_db_column(:action).of_type(:string) }
      it { is_expected.to have_db_column(:url).of_type(:text) }

      it { is_expected.to have_db_column(:created_at).of_type(:datetime) }
      it { is_expected.to have_db_column(:updated_at).of_type(:datetime) }
    end

    describe 'indexes' do
      it { is_expected.to have_db_column(:transparency_page).of_type(:string) }
      it { is_expected.to have_db_column(:answer).of_type(:integer) }
      it { is_expected.to have_db_column(:date).of_type(:date) }
    end
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:transparency_page) }
    it { is_expected.to validate_presence_of(:answer) }
    it { is_expected.to validate_presence_of(:date) }
    it { is_expected.to validate_presence_of(:controller) }
    it { is_expected.to validate_presence_of(:action) }
    it { is_expected.to validate_presence_of(:url) }
  end

  describe 'enums' do
    it 'answer' do
      answers = [
        :very_satisfied,
        :very_dissatisfied,
        :neutral,
        :somewhat_dissatisfied,
        :somewhat_satisfied
      ]

      is_expected.to define_enum_for(:answer).with_values(answers)
    end
  end

  describe 'callbacks' do
    it 'calcule_evaluation_note' do
      very_dissatisfied = create(:transparency_survey_answer, answer: :very_dissatisfied)
      somewhat_dissatisfied = create(:transparency_survey_answer, answer: :somewhat_dissatisfied)
      neutral = create(:transparency_survey_answer, answer: :neutral)
      somewhat_satisfied = create(:transparency_survey_answer, answer: :somewhat_satisfied)
      very_satisfied = create(:transparency_survey_answer, answer: :very_satisfied)

      expect(very_dissatisfied.evaluation_note).to eq(1)
      expect(somewhat_dissatisfied.evaluation_note).to eq(2)
      expect(neutral.evaluation_note).to eq(3)
      expect(somewhat_satisfied.evaluation_note).to eq(4)
      expect(very_satisfied.evaluation_note).to eq(5)
    end
  end
end
