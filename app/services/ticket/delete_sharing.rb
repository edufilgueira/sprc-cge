class Ticket::DeleteSharing

  attr_accessor :ticket, :ticket_parent, :current_user

  def initialize(ticket_id, current_user_id)
    @ticket = Ticket.find(ticket_id)

    @ticket_parent = ticket.parent || ticket
    @current_user = User.find(current_user_id)
  end

  def self.call(ticket_id, current_user_id)
    new(ticket_id, current_user_id).call
  end


  # privates

  def call
    return false unless ticket.destroy

    ticket_parent.waiting_referral! if ticket_parent.tickets.empty?
    register_log
    true
  end

  def register_log
    data = {
      protocol: ticket.parent_protocol,
      organ: ticket.organ_acronym
    }
    RegisterTicketLog.call(ticket, current_user, :delete_share, { data: data })
    RegisterTicketLog.call(ticket_parent, current_user, :delete_share, { data: data })
  end
end
