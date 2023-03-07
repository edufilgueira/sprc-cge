class Ticket::Deadline::Evaluate
  def msg_log(msg, protocol= nil)
    puts "RA.PRAZO #{msg} #{protocol} #{Time.now}"
    STDOUT.flush
  end

  def self.call
    new.call
  end

  def call

    msg_log('INICIO')

    if tickets.present?
      tickets.each do |ticket|
        next if ticket.deadline_ends_at.blank?
        #Atualização do Prazo
        ticket.deadline = calculate_deadline(ticket.deadline_ends_at)
        ticket.deadline_updated_at = DateTime.now
        ticket.save

        update_ticket_departments_deadline(ticket)

        msg_log('Protocolo:', ticket.parent_protocol)

        notify(ticket)
      end
    end
    msg_log('FIM')
  end

  private

  def tickets
    # criar escopo
    @tickets ||= Ticket.need_update_deadline
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
end