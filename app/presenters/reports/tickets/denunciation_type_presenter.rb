class Reports::Tickets::DenunciationTypePresenter
  include ::Reports::Tickets::ScopePresenter

  COLUMNS = [
    :organ,
    :replied_on_time,
    :replied_out_of_time,
    :open_on_time,
    :open_out_of_time,
    :solvability
  ]

  attr_reader :scope, :solvability_report

  def initialize(scope, solvability_report)
    @scope = scope
    @solvability_report = solvability_report
  end

  def rows
    organs.map do |organ|
      row(organ)
    end
  end

  private

  def organs
    ExecutiveOrgan.enabled.sorted
  end

  def row(organ)
    service = solvability(organ)

    [
      organ.acronym,
      service.replied_and_not_expired_count,
      service.replied_and_expired_count,
      service.confirmed_and_not_expired_count,
      service.confirmed_and_expired_count,
      solvability_str(service.call)
    ]
  end

  def solvability(organ)
    Ticket::Solvability::SectoralService.new(scope, organ.id, beginning_date, end_date)
  end

  def solvability_str(percentage)
    (percentage || 0.0).round(2)
  end

  def beginning_date
    return Date.new(0) unless date_filter.present?
    date_filter[:start].to_date
  end

  def end_date
    return Date.today.end_of_day unless date_filter.present?
    date_filter[:end].to_date.end_of_day
  end

  def date_filter
    solvability_report.filters[:confirmed_at]
  end
end
