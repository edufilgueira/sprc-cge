class Reports::Tickets::Sou::SouTypePresenter < Reports::Tickets::BasePresenter
  include ActionView::Helpers::NumberHelper

  def sou_type_count(sou_type)
    tickets = scope.with_sou_type(sou_type)

    within_confirmed_at(tickets).count + reopened_count(tickets)
  end

  def sou_type_str(sou_type)
    Ticket.human_attribute_name("sou_type.#{sou_type}")
  end

  def sou_type_percentage(sou_type)
    total_type = sou_type_count(sou_type)

    return '0.00%' if total_count == 0

    percentage = (total_type.to_f * 100)/total_count
    number_to_percentage(percentage, precision: 2)
  end

  def total_count
    @total_count ||= within_confirmed_at(scope).count + reopened_count(scope)
  end
end
