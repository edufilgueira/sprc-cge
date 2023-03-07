module Reports::Tickets::GenderPresenter
  attr_reader :scope

   COLUMNS = [
    :gender,
    :count,
    :percentage
  ]

  def initialize(scope, ticket_report=nil)
    @scope = scope
    @ticket_report = ticket_report
  end

  def gender_count(gender)
    tickets = scope.where(gender: gender)
    within_confirmed_at(tickets).count + reopened_count(tickets)
  end

  def gender_percentage(gender)
    return 0 unless total_count > 0

    (gender_count(gender).to_f * 100 / total_count).round(2)
  end

  def gender_str(gender)
    gender ||= 'empty'
    I18n.t("ticket.genders.#{gender}")
  end

  def total_count
    @total_count ||= within_confirmed_at(scope).count + reopened_count(scope)
  end
end
