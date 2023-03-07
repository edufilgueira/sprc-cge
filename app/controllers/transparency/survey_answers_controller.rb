class Transparency::SurveyAnswersController < TransparencyController

  PERMITTED_PARAMS = [
    :transparency_page,
    :answer,
    :email,
    :message,
    :controller,
    :action,
    :url
  ]

  def create
    survey_answer.date = Date.today

    if survey_answer.save
      render(partial: 'shared/transparency/survey_answers/create', locals: locals)
    else
      render(partial: 'shared/transparency/survey_answers/form', locals: locals)
    end
  end

  private

  def survey_answer
    @survey_answer ||= Transparency::SurveyAnswer.new(resource_params)
  end

  def resource_params
    if params[resource_symbol]
      params.require(resource_symbol).permit(PERMITTED_PARAMS)
    end
  end

  def resource_symbol
    :transparency_survey_answer
  end

  def locals
   { survey_answer: survey_answer, transparency_id: survey_answer.transparency_page }
  end
end
