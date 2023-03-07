class Reports::Tickets::Report::Sic::BaseService < Reports::Tickets::Report::BaseService

  private

  def report_scope
    csai_only(default_scope)
  end

  # CSAI
  # - com órgão
  # - com pai sem atendimento
  # - com pai com atendimento que seja :sic_forward
  def csai_only(scope)
    scope = scope.left_joins(parent: :attendance)
    scope.where(attendances: { id: nil }).or(
      scope.where(attendances: { service_type: service_types_for_ticket }))
  end

  #
  # Tipos de serviço do atendimento que geram algum ticket
  #
  # Precisamos considerar os que geram manifestação também pois
  # ele pode ser convertido para solicitação posteriormente
  #
  def service_types_for_ticket
    [
      Attendance.service_types[:sic_forward],
      Attendance.service_types[:sou_forward]
    ]
  end
end
