class Reports::Tickets::EvaluationPresenter

  attr_reader :scope

  def initialize(scope)
    @scope = scope
  end

  def question_average(question_name)
    return 0 if scope_count == 0
    (scope.sum(question_name) / scope_count.to_f).round(2)
  end

  def question_name(question,ticket_type)
    description_str = I18n.t("shared.answers.evaluations.questions.#{ticket_type}.#{question}.description")
    ActionController::Base.helpers.sanitize(description_str, tags: [])
  end

  def average_arr(arr)
    return 0 if arr.size == 0
    (arr.sum.to_f / arr.size).round(2)
  end

  def citizen_expectation(arr)
    return 0 if arr.size == 0
    (arr[1].to_f - arr[0].to_f) / arr[0]
  end

  def question05_count(evaluation_scope)
    evaluation_scope.count(:question_05)
  end

  def question05_average(evaluation_scope, option)
    (evaluation_scope.where("evaluations.question_05 = '#{option}'")
      .count / question05_count(evaluation_scope).to_f).to_f
  end

  def question05_sum(evaluation_scope, option, ticket_report_type)
    evaluation_scope.where(question_05: option.to_s, evaluation_type: ticket_report_type).count
  end

  private

  def scope_count
    @scope_count ||= scope.count
  end
end
