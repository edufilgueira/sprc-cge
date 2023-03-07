class Notifier::Extension < BaseNotifier

  attr_accessor :extension

  def self.call(extension_id, current_user_id = nil)
    new(extension_id, current_user_id).call
  end

  def initialize(extension_id, current_user_id)
    @extension = ::Extension.find(extension_id)
    @ticket = extension.ticket
    @current_user = User.find(current_user_id) if current_user_id.present?
  end


  # privates

  private

  def recipients
    (sectorals + subnets + users_ticket_owner).uniq
  end

  def sectorals
    return [] if extension.in_progress? && sectoral_or_subnet
    User.sectorals_from_organ_and_type(ticket_organ, ticket_type).enabled
  end

  def subnets
    return [] if  ticket_subnet.blank? || (extension.in_progress? && sectoral_or_subnet)
    User.subnet_sectoral.from_subnet(ticket_subnet)
  end

  def sectoral_or_subnet
    current_user.sectoral? || current_user.subnet_sectoral?
  end

  def subject(user)
    namespace = namespace(user)
    protocol = protocol_for_user(user)
    I18n.t("shared.notifications.messages.extension.#{status}.#{namespace}.subject.#{ticket_type}", protocol: protocol)
  end

  def status
    extension.status
  end

  def ticket_subnet
    ticket.subnet
  end

  def ticket_organ
    ticket.organ
  end

  def ticket_url(user)
    url_for([namespace(user), :ticket, id: ticket_for_user(user).id])
  end

  def body(user)
    url = ticket_url(user)
    namespace = namespace(user)
    protocol = protocol_for_user(user)
    user_name = current_user&.name

    I18n.t("shared.notifications.messages.extension.#{status}.#{namespace}.body.#{ticket_type}",
      user_name: user_name, protocol: protocol, url: url)
  end
end
