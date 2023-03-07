class Notifier::Referral::AdditionalUserRejected < BaseNotifier

  def self.call(ticket_id, ticket_department_email_id, current_user_id, justification)
    new(ticket_id, ticket_department_email_id, current_user_id, justification).call
  end

  def initialize(ticket_id, ticket_department_email_id, current_user_id, justification)
    @ticket = Ticket.find(ticket_id)
    @ticket_department_email = TicketDepartmentEmail.find(ticket_department_email_id)
    @current_user = User.find(current_user_id)
    @justification = justification
  end


  # private

  private

  def recipients
    [@ticket_department_email]
  end

  def subject(_user)
    I18n.t("shared.notifications.messages.referral.additional_user_rejected.operator.department.subject.#{ticket_type}", protocol: @ticket.parent_protocol)
  end

  def body(_user)
    I18n.t("shared.notifications.messages.referral.additional_user_rejected.operator.department.body.#{ticket_type}", user_name: @current_user.name,
      protocol: @ticket.parent_protocol, url: edit_positioning_url(@ticket_department_email.token), justification: @justification)
  end

  def user_notificable?(_user)
    true
  end

  def send_mail?(_user)
    true
  end
end
