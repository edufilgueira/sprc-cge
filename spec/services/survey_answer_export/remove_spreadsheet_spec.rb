require 'rails_helper'

describe SurveyAnswerExport::RemoveSpreadsheet do

  it 'remove file' do
    create(:transparency_survey_answer)

    survey_answer_export = create(:survey_answer_export, worksheet_format: 'xlsx')

    SurveyAnswerExport::CreateSpreadsheet.call(survey_answer_export.id)
    SurveyAnswerExport::RemoveSpreadsheet.call(survey_answer_export.filepath)

    dirpath = Rails.root.join('public', 'files', 'downloads', 'survey_answer_exports')

    survey_answer_export.reload

    filename = survey_answer_export.filename

    filepath = "#{dirpath}/#{filename}"

    expect(File.exist?(filepath)).to be_falsey
  end
end
