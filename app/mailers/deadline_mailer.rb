class DeadlineMailer < ApplicationMailer
  layout 'mailer'

  def result
    mail_to = 'cttecnico@cge.ce.gov.br'

    if ticket_ids.count.zero?
        subject = t('.subject_success')
        @message = t('.success_body_message')
    else
        ticket_joined_ids = ticket_ids.join(', ')
        subject = t('.subject_failure')
        @message = t('.failure_body_message', { ticket_joined_ids: ticket_joined_ids, ticket_ids_count: @ticket_ids.count })
    end

    mail(to: mail_to, subject: subject)
  end

  private

  def ticket_ids
    @outdated_tickets = Ticket.deadline_outdated
    @invalid_tickets = Ticket.deadline_invalid

    @ticket_ids ||= (@outdated_tickets.pluck(:id) + @invalid_tickets.pluck(:id)).uniq
  end
end