class Notifier::Invalidate < BaseNotifier

  def self.call(ticket_id, current_user_id = nil)
    new(ticket_id, current_user_id).call
  end

  def initialize(ticket_id, current_user_id)
    @current_user = User.find(current_user_id) if current_user_id.present?
    @ticket = Ticket.find(ticket_id)
  end


  # privates

  private

  def recipients
    (cge + users_ticket_owner)
  end

  def cge
    return [] if current_user.cge?

    super
  end

  def subject(user)
    namespace = namespace(user)
    protocol = protocol_for_user(user)
    I18n.t("shared.notifications.messages.invalidate.#{namespace}.subject.#{ticket_type}", protocol: protocol)
  end

  def body(user)
    namespace = namespace(user)
    url = ticket_url(user)
    protocol = protocol_for_user(user)
    user_name = current_user.name

    I18n.t("shared.notifications.messages.invalidate.#{namespace}.body.#{ticket_type}",
      user_name: user_name, protocol: protocol, url: url)
  end
end
