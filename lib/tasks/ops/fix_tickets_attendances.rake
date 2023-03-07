namespace :ops do

  task fix_tickets_attendances: :environment do

    Ticket.transaction do
      TICKETS_ORGAN = [
        ['5016123', 'CAGECE'],
        ['5015512', 'CAGECE'],
        ['5018050', 'METROFOR'],
        ['5018389', 'STDS'],
        ['5015544', 'CGE'],
        ['5018870', 'CAGECE'],
        ['5019012', 'CAGECE'],
        ['5014086', 'CAGECE'],
        ['5016867', 'CGE'],
        ['5016139', 'SEFAZ'],
        ['5017970', 'CAGECE'],
        ['5017457', 'CGE'],
        ['5016671', 'CGE'],
        ['5021141', 'CGE'],
        ['5019511', 'CGE'],
        ['5017591', 'METROFOR'],
        ['5017127', 'CAGECE'],
        ['5015443', 'CAGECE'],
        ['5018201', 'CBMCE'],
        ['5020799', 'CAGECE'],
        ['5018229', 'CGE'],
        ['5018692', 'CGE'],
        ['5020665', 'CAGECE'],
        ['5022144', 'CGE'],
        ['5021233', 'CGE'],
        ['5019541', 'CGE'],
        ['5019761', 'METROFOR'],
        ['5019837', 'CAGECE'],
        ['5019810', 'CAGECE'],
        ['5003146', 'PMCE'],
        ['5019913', 'CAGECE'],
        ['5020017', 'SESA'],
        ['5022120', 'CGE'],
        ['5003662', 'CAGECE'],
        ['5021934', 'CGE'],
        ['5021185', 'CGE'],
        ['5013969', 'CAGECE'],
        ['5021606', 'DETRAN'],
        ['5014013', 'SEFAZ'],
        ['5016845', 'CGE'],
        ['5015188', 'CAGECE'],
        ['5009042', 'SCIDADES'],
        ['5016886', 'CAGECE'],
        ['5014127', 'CGE'],
        ['5016993', 'CGE'],
        ['5018187', 'DETRAN'],
        ['5017959', 'METROFOR'],
        ['5018149', 'CGE'],
        ['5018965', 'CAGECE'],
        ['5019814', 'SEPLAG']
      ]

      TICKETS_ORGAN.each do |ticket_organ|
        ticket_parent = Ticket.find_by(protocol: ticket_organ[0])

        next if ticket_parent.blank?

        organ = Organ.find_by(acronym: ticket_organ[1])
        attendance = Attendance.find_by(ticket_id: ticket_parent.id)
        current_user = ticket_parent.created_by

        ticket_parent.unknown_organ = false
        ticket_parent.organ_id = organ.id
        ticket_parent.create_ticket_child

        if attendance.completed?
          ticket_parent.tickets.each do |ticket_child|
            answer = ticket_parent.answers.first
            attributes = { resource: answer, data: ticket_log_data(ticket_child, current_user) }

            RegisterTicketLog.call(ticket_child, current_user, :answer, attributes)
            ticket_child.created_at = ticket_parent.created_at
            ticket_child.save
          end
        end
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
