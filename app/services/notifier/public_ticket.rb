#
# Serviço de notificação do ticket publico
#
class Notifier::PublicTicket < BaseNotifier

  attr_reader :users, :ticket, :ticket_log

  def self.call(ticket_log_id)
    new(ticket_log_id).call
  end

  def initialize(ticket_log_id)
    @ticket_log = TicketLog.find(ticket_log_id)
    @ticket = @ticket_log.ticket
    @users = @ticket.subscribers
  end


  # private

  private

  def user_notificable?(_user)
    true
  end

  def email_allowed?(_user)
    false
  end

  def ticket_type
    ticket.ticket_type
  end

  def recipients
    @users
  end

  def subject(_user)
    protocol = ticket.parent_protocol

    I18n.t("shared.notifications.public_ticket.#{ticket_log.action}.#{ticket_type}.subject",
      protocol: protocol)
  end

  def body(_user)
    protocol = ticket.parent_protocol
    url = transparency_public_ticket_url(ticket)

    I18n.t("shared.notifications.public_ticket.#{ticket_log.action}.#{ticket_type}.body",
      protocol: protocol, url: url)
  end
end
