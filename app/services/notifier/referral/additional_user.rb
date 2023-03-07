class Notifier::Referral::AdditionalUser < BaseNotifier

  def self.call(ticket_id, ticket_department_email_id, current_user_id)
    new(ticket_id, ticket_department_email_id, current_user_id).call
  end

  def initialize(ticket_id, ticket_department_email_id, current_user_id)
    @ticket = Ticket.find(ticket_id)
    @ticket_department_email = TicketDepartmentEmail.find(ticket_department_email_id)
    @current_user = User.find(current_user_id)
  end


  # private

  private

  def recipients
    [@ticket_department_email]
  end

  def subject(_user)
    I18n.t("shared.notifications.messages.referral.operator.department.subject.#{ticket_type}", protocol: @ticket.parent_protocol)
  end

  def body(_user)
    I18n.t("shared.notifications.messages.referral.operator.department.body.#{ticket_type}", body_locale_params)
  end

  def user_notificable?(_user)
    true
  end

  def send_mail?(_user)
    true
  end

  def ticket_department
    @ticket_department ||= @ticket_department_email.ticket_department
  end

  def considerations
    return ticket_department.considerations if ticket_department.considerations.present?
    I18n.t("shared.notifications.messages.referral.operator.considerations.empty")
  end

  def body_locale_params
    {
      user_name: @current_user.name,
      protocol: @ticket.parent_protocol,
      url: edit_positioning_url(@ticket_department_email.token),
      considerations: considerations
    }
  end
end
