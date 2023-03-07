class Notifier::Appeal < BaseNotifier

  def self.call(ticket_id)
    new(ticket_id).call
  end

  def initialize(ticket_id)
    @ticket = Ticket.find(ticket_id)
  end


  # privates

  private

  def recipients
    cge
  end

  def subject(user)
    protocol = protocol_for_user(user)
    I18n.t('shared.notifications.messages.appeal.operator.subject', protocol: protocol)
  end

  def body(user)
    url = ticket_url(user)
    protocol = protocol_for_user(user)

    I18n.t('shared.notifications.messages.appeal.operator.body',
      protocol: protocol, url: url)
  end
end
