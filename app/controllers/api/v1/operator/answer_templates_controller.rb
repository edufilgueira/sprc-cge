class Api::V1::Operator::AnswerTemplatesController < Api::V1::OperatorController

  PERMITTED_PARAMS = [
    :name,
    :content
  ]

  def search
    resources = JSON.parse(filtered_resources.to_json(only: PERMITTED_PARAMS))
    object_response(resources)
  end

  private

  def default_scope
    current_user.answer_templates
  end

  def param_name
    params[:name]
  end

  def filtered_resources
    default_scope.search(param_name)
  end

  def blank_option
    { "#{I18n.t('messages.form.select')}": '' }
  end


  def answer_templates_for_select
    filtered_resources.pluck(:name, :content).to_h
  end
end
