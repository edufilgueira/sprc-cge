class Reports::Tickets::Evaluations::SummaryPresenter

  attr_reader :scope

  def initialize(scope)
    @scope = scope
  end

  def scope_count
    scope.count
  end

  def question05_count
    scope.count(:question_05)
  end

  def question_average(question_name)
    return 0 if scope_count == 0
    (scope.sum(question_name) / scope_count.to_f).round(2)
  end
  
  def question05_average(value)
    return 0 if question05_count == 0
    (scope.where("evaluations.question_05 = '#{value}'")
      .count / question05_count.to_f).to_f
  end

  def question05_sum(value)
    return 0 if question05_count == 0
    (scope.where("evaluations.question_05 = '#{value}'").count)
  end

  def question_name(question,ticket_type)
    t_base = 'shared.answers.evaluations.questions'
    description_str = I18n.t("#{t_base}.#{ticket_type}.#{question}.description")
    ActionController::Base.helpers.sanitize(description_str, tags: [])
  end

end
