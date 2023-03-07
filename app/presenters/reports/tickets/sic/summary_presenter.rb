class Reports::Tickets::Sic::SummaryPresenter < Reports::Tickets::Sic::BasePresenter

  def relevant_to_executive_count
    within_confirmed_at(scope).count
  end

  def call_center_sic_count
    confirmed_scope = within_confirmed_at(scope)
    confirmed_scope.joins(parent: :attendance).count + confirmed_scope.joins(:attendance).count
  end

  # Devemos incluir o sou_forward pois o atendimento pode ter sido originalmente criado como SOU
  # e depois foi alterado para SIC
  def call_center_forwarded_count
    within_confirmed_at(scope).joins(parent: :attendance).where(attendances: { service_type: [:sic_forward, :sou_forward] }).count
  end

  def sic_without_attendance_count
    tickets = within_confirmed_at(scope).where(attendances: { id: nil })
    tickets_count(tickets)
  end

  def call_center_finalized_count
    tickets = within_confirmed_at(scope).where(attendances: { service_type: :sic_completed })
    tickets_count(tickets)
  end

  def finalized_without_call_center_count
    tickets = csai_only(within_confirmed_at(scope))

    tickets_count(reopened_in_range(tickets).final_answer) + tickets_count(reopened_out_range(tickets))
  end

  # Metodo necessario devido ao metodo dessa classe translate receber objetos
  # dinamicamente e nao passar o scope
  def reopened_count
    reopened_scope(scope).count
  end

  def average_time_answer
    return 0 if responded_scope.blank?
    total_days_answer/responded_scope.count
  end

  def relevant_to_executive_count_str
    translate :relevant_to_executive_count
  end

  def call_center_sic_count_str
    translate :call_center_sic_count
  end

  def call_center_forwarded_count_str
    translate :call_center_forwarded_count
  end

  def sic_without_attendance_count_str
    translate :sic_without_attendance_count
  end

  def call_center_finalized_count_str
    translate :call_center_finalized_count
  end

  def finalized_without_call_center_count_str
    translate :finalized_without_call_center_count
  end

  def reopened_count_str
    translate :reopened_count
  end

  def average_time_answer_str
    translate :average_time_answer
  end

  private

  def translate(method_name)
    I18n.t("presenters.reports.tickets.sic.summary.#{method_name}", count: send(method_name))
  end

  def responded_scope
    @responded_scope ||=
      (default_responded_scope(within_confirmed_at(scope)) + default_responded_scope(tickets_log_scope(scope))).uniq
  end

  def default_responded_scope(tickets)
    tickets.where.not(responded_at: nil).without_other_organs.without_internal_status(Ticket::INVALIDATED_STATUSES)
  end

  def tickets_log_scope tickets
    tickets.joins(:ticket_logs).where(ticket_logs: { created_at: date_range })
  end

  def total_days_answer
    @total_days_answer ||= responded_scope.sum { |ticket|
      ticket.average_days_spent_to_answer date_range
    }
  end
end
