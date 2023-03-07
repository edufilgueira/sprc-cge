require 'rails_helper'

describe SurveyAnswerExport do

  subject(:survey_answer_export) { create(:survey_answer_export) }

  describe 'factories' do
    it { is_expected.to be_valid }
  end

  describe 'db' do
    describe 'columns' do
      it { is_expected.to have_db_column(:name).of_type(:string) }
      it { is_expected.to have_db_column(:start_at).of_type(:datetime) }
      it { is_expected.to have_db_column(:ends_at).of_type(:datetime) }
      it { is_expected.to have_db_column(:status).of_type(:integer) }
      it { is_expected.to have_db_column(:worksheet_format).of_type(:integer) }
      it { is_expected.to have_db_column(:filename).of_type(:string) }
      it { is_expected.to have_db_column(:log).of_type(:string) }
      it { is_expected.to have_db_column(:user_id).of_type(:integer) }

      it { is_expected.to have_db_column(:created_at).of_type(:datetime) }
      it { is_expected.to have_db_column(:updated_at).of_type(:datetime) }
    end
  end

  describe 'associations' do
    it { is_expected.to belong_to(:user) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:start_at) }
    it { is_expected.to validate_presence_of(:ends_at) }
    it { is_expected.to validate_presence_of(:worksheet_format) }
    it { is_expected.to validate_presence_of(:user) }

    it { is_expected.to validate_inclusion_of(:ends_at).in_range(survey_answer_export.start_at..Date.today) }
  end

  describe 'enums' do
    it 'answer' do
      statuses = [:queued, :in_progress, :error, :success]

      is_expected.to define_enum_for(:status).with_values(statuses)
    end

    it 'worksheet_format' do
      worksheet_formats = [:xlsx, :csv]

      is_expected.to define_enum_for(:worksheet_format).with_values(worksheet_formats)
    end
  end

  describe 'delegations' do
    it { is_expected.to delegate_method(:title).to(:user).with_prefix }
  end

  describe 'callbacks' do
    it 'success generated' do
      survey_answer_export = create(:survey_answer_export, status: :success)

      service = double
      allow(SurveyAnswerExport::RemoveSpreadsheet).to receive(:delay) { service }
      allow(service).to receive(:call)

      filepath = survey_answer_export.filepath
      SurveyAnswerExport.destroy(survey_answer_export.id)

      expect(service).to have_received(:call).with(filepath)
    end

    it 'no success generated' do
      survey_answer_export = create(:survey_answer_export)

      service = double
      allow(SurveyAnswerExport::RemoveSpreadsheet).to receive(:delay) { service }
      allow(service).to receive(:call)

      filepath = survey_answer_export.filepath
      SurveyAnswerExport.destroy(survey_answer_export.id)

      expect(service).not_to have_received(:call).with(filepath)
    end
  end

  describe 'helpers' do
    it 'title' do
      expected = survey_answer_export.name

      expect(survey_answer_export.title).to eq(expected)
    end

    it 'dirpath' do
      expected = Rails.root.join('public', 'files', 'downloads', 'survey_answer_exports')

      expect(survey_answer_export.dirpath).to eq(expected)
    end

    it 'filepath' do
      expected = "#{survey_answer_export.dirpath}/#{survey_answer_export.filename}"

      expect(survey_answer_export.filepath).to eq(expected)
    end
  end
end
