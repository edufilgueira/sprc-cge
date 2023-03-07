namespace :add_email_forward_ticket_log do
  task migrate: :environment do
    ticket_logs = TicketLog.forward

    ticket_logs.each do |ticket_log|
      ticket = ticket_log.ticket

      unless ticket.parent?
        ticket_department = ticket.ticket_departments.find_by(department_id: ticket_log.resource)

        next if ticket_department.blank?

        data = { emails: ticket_department.ticket_department_emails.map(&:email) }
        ticket_log.data = data

        ticket_log_parent = ticket.parent.ticket_logs.find_by(resource: ticket_log.resource, action: :forward)
        ticket_log_parent.data = data

        ticket_log_parent.save
        ticket_log.save
      end
    end
  end
end
