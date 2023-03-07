class Answer::BaseService

  private

  def all_active_children_partial_replied?
    parent_ticket.present? && parent_ticket.tickets.active.all?(&:partial_answer?)
  end

  def update_answer
    answer.update(status: answer_status, deadline: ticket.deadline)
  end

  def update_ticket_logs
    create_answer_updated_log
    create_answer_cge_approved_or_rejected_log

    ticket_logs.each do |ticket_log|
      ticket_log.description = justification if justification.present?
      ticket_log.data[:responsible_user_evaluated_answer_id] = user.id
      ticket_log.save
    end
  end

  def create_answer_updated_log
    #
    # No momento de aprovar ou rejeitar uma resposta é verificado se a descrição original diverge a editada
    # se sim. é gerado um log
    #
    if answer.modified_description?
      RegisterTicketLog.call(parent_ticket, user, :answer_updated, { resource: answer, data: data_attributes })
    end
  end

  def create_answer_cge_approved_or_rejected_log
    #
    # Gera log de aprovação e rejeição do Operador CGE
    #
    if (answer.cge_approved? || answer.cge_rejected?) && user.cge?
      action = "answer_#{answer_status}".to_sym
      RegisterTicketLog.call(parent_ticket, user, action, { resource: answer, data: data_attributes })
    end
  end

  def data_attributes
    {
      acronym: ombudsman_acronym,
      responsible_as_author: user.as_author
    }
  end

  def ombudsman_acronym
    return ticket.subnet_acronym if ticket.subnet?

    ticket.organ.acronym
  end

  def ticket_log
    answer.ticket_log
  end

  def ticket_logs
    answer.ticket_logs
  end
end
