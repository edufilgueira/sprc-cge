class Notifier::Extension::Chief < BaseNotifier

  attr_accessor :extension

  def self.call(extension_id, current_user_id)
    new(extension_id, current_user_id).call
  end

  def initialize(extension_id, current_user_id)
    @extension = ::Extension.find(extension_id)
    @ticket = extension.ticket
    @current_user = User.find(current_user_id)
  end


  # privates

  private

  def recipients
    chiefs
  end

  def chiefs
    return [] unless extension.in_progress?
    extension.extension_users.map(&:user)
  end

  def notification_role(user)
    notification_roles = user.notification_roles
    notification_roles[:extension]
  end

  def subject(user)
    protocol = protocol_for_user(user)
    I18n.t("shared.notifications.messages.extension.#{status}.operator.chief.subject.#{ticket_type}", protocol: protocol)
  end

  def status
    extension.status
  end

  def body(user)
    extension_user = extension.extension_users.find_by(user: user)

    url = edit_extension_url(id: extension_user.token)
    protocol = protocol_for_user(user)
    user_name = current_user.name

    I18n.t("shared.notifications.messages.extension.#{status}.operator.chief.body.#{ticket_type}",
      user_name: user_name, protocol: protocol, url: url)
  end
end
