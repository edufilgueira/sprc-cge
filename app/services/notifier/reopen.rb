class Notifier::Reopen < BaseNotifier

  def self.call(ticket_id)
    new(ticket_id).call
  end

  def initialize(ticket_id)
    @ticket = Ticket.find(ticket_id)
  end


  # privates

  private

  def recipients
    cge + sectorals + subnets
  end

  def sectorals
    User.sectorals_from_organ_and_type(ticket_organ, ticket_type).enabled
  end

  def subnets
    return [] unless ticket_subnet.present?

    User.subnet_sectoral.from_subnet(ticket_subnet)
  end

  def ticket_organ
    ticket.organ
  end

  def ticket_subnet
    ticket.subnet
  end

  def subject(user)
    protocol = protocol_for_user(user)
    I18n.t("shared.notifications.messages.reopen.operator.subject.#{ticket_type}", protocol: protocol)
  end

  def body(user)
    url = ticket_url(user)
    protocol = protocol_for_user(user)

    I18n.t("shared.notifications.messages.reopen.operator.body.#{ticket_type}",
      protocol: protocol, url: url)
  end
end
