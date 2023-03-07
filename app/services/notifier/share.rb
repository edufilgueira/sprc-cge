class Notifier::Share < BaseNotifier

  def self.call(ticket_id, current_user_id = nil)
    new(ticket_id, current_user_id).call
  end

  def initialize(ticket_id, current_user_id)
    @current_user = User.find(current_user_id) if current_user_id.present?
    @ticket = Ticket.find(ticket_id)
  end


  # private

  private

  def recipients
    (sectorals + subnets + users_ticket_owner).uniq
  end

  def subnets
    return [] unless ticket_subnet.present?

    User.subnet_sectoral.from_subnet(ticket_subnet)
  end

  def sectorals
    User.sectorals_from_organ_and_type(ticket_organ, ticket_type).enabled
  end

  def subject(user)
    namespace = namespace(user)
    protocol = protocol_for_user(user)
    I18n.t("shared.notifications.messages.share.#{namespace}.subject.#{ticket_type}", protocol: protocol)
  end

  def ticket_organ
    ticket.organ
  end

  def ticket_subnet
    ticket.subnet
  end

  def ticket_for_user(user)
    return ticket_parent if user.is_a?(Ticket)

    (user.user?) ? ticket_parent : ticket_child(user)
  end

  def body(user)
    namespace = namespace(user)
    url = ticket_url(user)
    protocol = protocol_for_user(user)
    user_name = current_user.name
    ombudsman_name = ticket_organ&.title || ticket_subnet&.title

    I18n.t("shared.notifications.messages.share.#{namespace}.body.#{ticket_type}",
      user_name: user_name, protocol: protocol, organ_name: ombudsman_name, url: url)
  end
end
