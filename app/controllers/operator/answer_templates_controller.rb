class Operator::AnswerTemplatesController < Operator::BaseCrudController
  include Operator::AnswerTemplates::Breadcrumbs

  PERMITTED_PARAMS = [
    :name,
    :content
  ]

  SORT_COLUMNS = {
    name: 'answer_templates.name'
  }

  helper_method [:answer_templates, :answer_template]


  # Helper methods

  def answer_templates
    paginated_resources
  end

  def answer_template
    resource
  end

  private

  def default_sort_scope
    current_user.answer_templates
  end

  def resources
    @resources ||= default_sort_scope
  end
end
