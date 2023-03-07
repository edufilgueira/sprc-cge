require 'rails_helper'

describe SurveyAnswerExportHelper do

  it 'survey_answer_export_worksheet_formats' do
    expected = SurveyAnswerExport.worksheet_formats.keys.map { |f| [ I18n.t("survey_answer_export.worksheet_formats.#{f}"), f] }

    expect(survey_answer_export_worksheet_formats).to eq(expected)
  end
end
