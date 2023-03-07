class DefineDecrementDeadlineTickets

  def self.call
    new.call
  end

  def call
    if tickets.present?
      tickets.each do |ticket|
        next if ticket.deadline_ends_at.blank?
        #Atualização do Prazo
        ticket.decrement_deadline = true
        ticket.save
      end
    end
  end

  private

  def tickets
    @tickets ||= Ticket.appeal.union(
      Ticket.waiting_referral.union(
        tickets_without_partial_answer.child_tickets.union(
          tickets_parents_for_update(tickets_without_partial_answer.parent_tickets)
        )
      )
    )
  end

  def update_ticket_departments_deadline(ticket)
    ticket.ticket_departments.each do |ticket_department|
      next if ticket_department.deadline_ends_at.blank?

      deadline = calculate_deadline(ticket_department.deadline_ends_at)

      ticket_department.update_attributes(deadline: deadline)
    end
  end

  def calculate_deadline(deadline_ends_at)
    (deadline_ends_at - Date.today).to_i
  end

  def notify(ticket)
    Notifier::Deadline.delay.call(ticket.id)
  end

  def tickets_parents_for_update(tickets_parents)
    tickets_parents.where(
      id: tickets_parents_ids_for_update(tickets_parents)
    )
  end

  def tickets_parents_ids_for_update(tickets_parents)
    parents_ids_for_update = []

    tickets_parents.each do |ticket_parent|
      ticket_parent.tickets.each do |ticket_child|
        if !child_with_final_or_partial_answer?(ticket_child) ||
          reopened_after_partial_or_final_answer?(ticket_child)
          # adicionando o ticket Pai para atualizar o prazo.
          parents_ids_for_update << ticket_parent.id
        end
      end
    end

    parents_ids_for_update
  end

  def reopened_after_partial_or_final_answer?(ticket_child)
    ticket_child.parent.reopened_at.present? &&
    (ticket_child.parent.reopened_at > ticket_child.answers.last.created_at)
  end

  def child_with_final_or_partial_answer?(ticket_child)
    ticket_child.answers.where(answer_type: [:partial, :final]).any?
  end

  def tickets_without_partial_answer
    Ticket.without_partial_answer.where.not(
      internal_status: Ticket::INACTIVE_STATUS_FOR_PARTIAL_RESPONSE
    )

  end
end