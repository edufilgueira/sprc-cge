class Ticket::EmailReply

  attr_accessor :ticket

  def self.call(ticket_id)
    new(ticket_id).call
  end

  def initialize(ticket_id)
    @ticket = Ticket.find(ticket_id)
  end

  def call
    send_email
  end


  # private

  private

  def send_email
    TicketMailer.email_reply(ticket_parent, replies).deliver if replies.present?
  end

  # -
  # - Envia apenas respostas finais e aprovadas
  # -
  def replies
    answers.final.where(status: Answer::VISIBLE_TO_USER_STATUSES)
  end

  def answers
    if ticket_parent.no_children?
      ticket_parent.answers
    else
      Answer.where(ticket: tickets)
    end
  end

  def ticket_parent
    ticket.parent || ticket
  end

  def tickets
    ticket_parent.tickets
  end

end
