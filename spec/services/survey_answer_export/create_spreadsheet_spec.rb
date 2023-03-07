require 'rails_helper'

describe SurveyAnswerExport::CreateSpreadsheet do

  it 'create xlsx' do
    create(:transparency_survey_answer)

    survey_answer_export = create(:survey_answer_export, name: 'teste', worksheet_format: 'xlsx')

    SurveyAnswerExport::CreateSpreadsheet.call(survey_answer_export.id)

    dirpath = Rails.root.join('public', 'files', 'downloads', 'survey_answer_exports')

    survey_answer_export.reload

    filename = survey_answer_export.filename
    status = survey_answer_export.status

    filepath = "#{dirpath}/#{filename}"

    expect(File.exist?(filepath)).to be_truthy

    expect(status).to eq("success")
  end

  it 'create csv' do
    create(:transparency_survey_answer)

    survey_answer_export = create(:survey_answer_export, worksheet_format: 'csv')

    SurveyAnswerExport::CreateSpreadsheet.call(survey_answer_export.id)

    dirpath = Rails.root.join('public', 'files', 'downloads', 'survey_answer_exports')

    survey_answer_export.reload

    filename = survey_answer_export.filename
    status = survey_answer_export.status

    filepath = "#{dirpath}/#{filename}"

    expect(File.exist?(filepath)).to be_truthy

    expect(status).to eq("success")
  end
end
