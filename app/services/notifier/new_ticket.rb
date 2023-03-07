#
# Serviço de notificação do ticket
#
class Notifier::NewTicket < BaseNotifier

  def self.call(ticket_id)
    new(ticket_id).call
  end

  def initialize(ticket_id)
    @ticket = Ticket.find(ticket_id)
  end


  # private

  private

  def recipients
    (operators + users_ticket_owner).uniq
  end

  def operators
    operators = []

    operators += User.sectorals_from_organ_and_type(tickets_organ, ticket_type).enabled

    operators += User.subnet_sectoral.from_subnet(tickets_subnet).enabled

    operators += cge if ticket.denunciation?

    operators
  end

  def tickets_organ
    all_organs_involved.present? ? all_organs_involved : ticket.organ
  end

  def tickets_subnet
    all_subnets_involved.present? ? all_subnets_involved : ticket.subnet
  end

  def subject(user)
    namespace = namespace(user)
    protocol = protocol_for_user(user)
    I18n.t("shared.notifications.messages.new_ticket.#{namespace}.subject.#{ticket_type}", protocol: protocol)
  end

  def body(user)
    namespace = namespace(user)
    ticket = ticket_for_user(user)
    protocol = protocol_for_user(user)
    created_by_name = ticket.name

    I18n.t("shared.notifications.messages.new_ticket.#{namespace}.body.#{ticket_type}.#{ticket.access_type}",
      name: created_by_name, protocol: protocol, url: ticket_url(user), password: ticket.plain_password)
  end
end
