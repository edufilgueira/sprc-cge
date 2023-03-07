module SurveyAnswerExportHelper

  def survey_answer_export_worksheet_formats
    SurveyAnswerExport.worksheet_formats.keys.map do |format_key|
      [ I18n.t("survey_answer_export.worksheet_formats.#{format_key}"), format_key ]
    end
  end
end
