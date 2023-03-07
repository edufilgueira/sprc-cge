#
# Serviço responsável em gerar notificações da mudança do tipo do ticket (sic -> sou / sou -> sic)
#
class Notifier::ChangeTicketType < BaseNotifier

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
    users = User.operator.where(organ: ticket_organs).enabled

    return users.sic_sectoral + users.sou_sectoral if ticket.sic?

    users.sou_sectoral
  end

  def subnets
    return [] unless ticket_subnets.present?

    User.subnet_sectoral.from_subnet(ticket_subnets)
  end

  def ticket_organs
    return [] if ticket.no_children?

    ticket.tickets.pluck(:organ_id)
  end

  def ticket_subnets
    return [] if ticket.no_children?

    ticket.tickets.pluck(:subnet_id)
  end

  def subject(user)
    protocol = protocol_for_user(user)

    I18n.t("shared.notifications.messages.change_ticket_type.#{ticket_type}.subject", protocol: protocol)
  end

  def body(user)
    url = ticket_url(user)
    protocol = protocol_for_user(user)

    I18n.t("shared.notifications.messages.change_ticket_type.#{ticket_type}.body", protocol: protocol, url: url)
  end
end
