class Reports::Tickets::Sic::AverageTimeAnswerPresenter < Reports::Tickets::Sic::BasePresenter
  attr_reader :scope

  def initialize(scope)
    @scope = scope
  end

  def average_type_str(average_type)
    I18n.t("presenters.reports.tickets.sic.average_time_answer.#{average_type}")
  end

  def average_time_str(average_type)
    I18n.t("presenters.reports.tickets.sic.average_time_answer.average_time" , count: average_time(average_type))
  end

  def average_time(average_type)
    current_scope = scope_report(average_type)
    total = tickets_count(current_scope)

    return 0 if total == 0

    total_days_answer(current_scope) / total
  end

  def amount_count(average_type)
    current_scope = scope_report(average_type)
    tickets_count(current_scope)
  end

  private

  def scope_report(average_type)
    current_scope = send("#{average_type}_scope")
    current_scope = current_scope.final_answer
    current_scope.where.not(responded_at: nil)
  end

  def call_center_and_csai_scope
    scope
  end

  def csai_scope
    # Todas finalizadas que foram criadas pelo órgão
    csai_only(scope)
  end

  def call_center_scope
    # Todas finalizadas pela central
    attendance_sic_completed(scope)
  end

  def total_days_answer(scope)
    tickets_attendance_scope(scope).sum { |t| t.average_days_spent_to_answer.to_i }
  end
end
