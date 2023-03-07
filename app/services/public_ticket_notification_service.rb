class PublicTicketNotificationService

  def self.call(ticket_log_id, action)
    new.call(ticket_log_id, action)
  end

  def call(ticket_log_id, action)
    Notifier::PublicTicket.delay.call(ticket_log_id)

    ticket_log = TicketLog.find(ticket_log_id)
    ticket_subscriptions_confirmed = ticket_log.ticket.ticket_subscriptions_confirmed

    ticket_subscriptions_confirmed.each do |ticket_subscription|
      TicketMailer.ticket_subscriber_notification(ticket_subscription.id, action).deliver_later
    end
  end
end
