class Reports::Tickets::Sic::AnswerPreferencePresenter < Reports::Tickets::Sic::BasePresenter

  include ActionView::Helpers::NumberHelper

  attr_reader :total_count

  def answer_type_count(answer_type)
    tickets = scope.with_answer_type(answer_type)
    within_confirmed_at(tickets).count + reopened_count(tickets)
  end

  def answer_type_percentage(answer_type)
    count = answer_type_count(answer_type)
    number_to_percentage(count.to_f * 100 / total_count, precision: 2) if total_count > 0
  end

  def total_count
    @total_count ||= within_confirmed_at(scope).count + reopened_count(scope)
  end

  def answer_type_str(answer_type)
    I18n.t("ticket.answer_types.#{answer_type}")
  end
end
