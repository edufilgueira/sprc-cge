module Operator::Reports::EvaluationExports::Filters
  include Operator::Reports::FiltersBase

  FILTERED_ENUMS = [
    :ticket_type,
    :sou_type,
    :used_input
  ]

  private

  def filtered_tickets
    scope = sorted_tickets

    filtered = filter_by_child_organ(scope)
    filtered = filter_by_date_range(filtered)

    filtered(Ticket, filtered)
  end
end
