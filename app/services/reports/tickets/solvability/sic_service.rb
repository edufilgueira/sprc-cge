class Reports::Tickets::Solvability::SicService < Reports::Tickets::Solvability::BaseService

  private

  def presenter
    @presenter ||= Reports::Tickets::SolvabilityPresenter.new(csai_only(default_scope), solvability_report)
  end

  # CSAI
  # - com órgão
  # - com pai sem atendimento
  # - com pai com atendimento que seja :sic_forward
  # - com pai com atendimento que seja :sou_forward
  def csai_only(scope)
    scope = scope.left_joins(parent: :attendance)
    scope.where(attendances: { id: nil }).or(
      scope.where(attendances: { service_type: service_types_for_ticket }))
  end

  def service_types_for_ticket
    [
      Attendance.service_types[:sic_forward],
      Attendance.service_types[:sou_forward]
    ]
  end
end
