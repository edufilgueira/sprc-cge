class Reports::Tickets::Sou::SolvabilityPresenter < Reports::Tickets::BasePresenter
  include ActionView::Helpers::NumberHelper

  attr_reader :service

  def initialize(scope, ticket_report)
    @scope = scope
    @ticket_report = ticket_report
    @service = Ticket::Solvability::SectoralService.new(scope, nil, beginning_date, end_date)
  end

  def solvability_count(solvability_name)
    #debugger
    send(solvability_name)
  end

  # Total de Manifestações finalizadas no prazo:
  def final_answers_in_deadline
    service.replied_and_not_expired_count
  end

  # Total de Manifestações finalizadas fora do prazo:
  def final_answers_out_deadline
    service.replied_and_expired_count
  end

  # Total de Manifestações pendentes no prazo
  def attendance_in_deadline
    service.confirmed_and_not_expired_count
  end

  # Total de Manifestações pendentes fora do prazo
  def attendance_out_deadline
    service.confirmed_and_expired_count
  end

  def total
    service.total_count
  end

  def resolubility
    number_to_percentage(service.resolubility, precision: 2)
  end

  def solvability_name(solvability_name)
    I18n.t("services.reports.tickets.sou.solvability.rows.#{solvability_name}")
  end

  def solvability_percentage(count)
    number_to_percentage(count.to_f * 100 / total, precision: 2) if total > 0
  end

end
