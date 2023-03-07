class Reports::Tickets::UsedInputPresenter < Reports::Tickets::BasePresenter
  include ActionView::Helpers::NumberHelper

  attr_reader :total_count

  def used_input_count(used_input)
    tickets = scope.with_used_input(used_input)
    within_confirmed_at(tickets).count + reopened_count(tickets)
  end

  def used_input_percentage(used_input)
    count = used_input_count(used_input)
    number_to_percentage(count.to_f * 100 / total_count, precision: 2) if total_count > 0
  end

  def total_count
    @total_count ||= within_confirmed_at(scope).count + reopened_count(scope)
  end

  def used_input_str(used_input)
    Ticket.human_attribute_name("used_input.#{used_input}")
  end
end
