# https://github.com/caiena/sprc/issues/1893
namespace :ops do

  task modify_tickets: :environment do

    Ticket.transaction do

      TICKETS = [ '5048159' , '5056069' ]

      TICKETS.each do |ticket|
        ticket_parent = Ticket.find_by(protocol: ticket)
        organ = Organ.find_by(acronym: 'CGE')

        current_user = ticket_parent.created_by

        ticket_parent.unknown_organ = false
        ticket_parent.organ_id = organ.id
        ticket_parent.create_ticket_child

        ticket_child = ticket_parent.tickets.first
        answer = ticket_parent.answers.first
        attributes = { resource: answer, data: ticket_log_data(ticket_child, current_user) }

        RegisterTicketLog.call(ticket_child, current_user, :answer, attributes)
        ticket_child.created_at = ticket_parent.created_at
        ticket_child.save

      end
    end
  end

  def ticket_log_data(ticket, current_user)
    {
      responsible_user_id: current_user.id,
      responsible_organ_id: ticket.organ_id,
      responsible_subnet_id: ticket.subnet_id
    }
  end
end
