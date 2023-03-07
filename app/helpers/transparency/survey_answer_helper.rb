module Transparency::SurveyAnswerHelper

  def transparency_survey_answer_options
    Transparency::SurveyAnswer.answers.keys.map do |o|
      [ Transparency::SurveyAnswer.human_attribute_name("answer.#{o}"), o ]
    end
  end
end
