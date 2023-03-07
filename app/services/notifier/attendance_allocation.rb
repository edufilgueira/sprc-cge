#
# Serviço de notificação do atendente 155 ao receber um ticket do supervisor
#
class Notifier::AttendanceAllocation < BaseNotifier

  attr_reader :user_call_center

  def self.call(ticket_id, user_call_center_id)
    new(ticket_id, user_call_center_id).call
  end

  def initialize(ticket_id, user_call_center_id)
    @ticket = Ticket.find(ticket_id)
    @user_call_center = User.find(user_call_center_id)
  end


  # private

  private

  def recipients
    [user_call_center] + users_ticket_owner
  end

  def subject(recipient)
    namespace = namespace(recipient)
    protocol = protocol_for_user(recipient)
    I18n.t("shared.notifications.messages.attendance_allocation.#{namespace}.subject.#{ticket_type}", protocol: protocol)
  end

  def body(recipient)
    namespace = namespace(recipient)
    protocol = protocol_for_user(recipient)

    I18n.t("shared.notifications.messages.attendance_allocation.#{namespace}.body.#{ticket_type}",
      protocol: protocol, url: ticket_url(recipient))
  end
end
