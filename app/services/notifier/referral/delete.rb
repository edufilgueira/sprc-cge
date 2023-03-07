class Notifier::Referral::Delete < BaseNotifier

  def self.call(ticket_department_id, current_user_id)
    new(ticket_department_id, current_user_id).call
  end

  def initialize(ticket_department_id, current_user_id)
    @ticket_department = ::TicketDepartment.with_deleted.find(ticket_department_id)
    @ticket = @ticket_department.ticket
    @department = @ticket_department.department
    @current_user = User.find(current_user_id)

    @department_emails = @ticket_department.ticket_department_emails.with_deleted
  end

  # private

  private

  def recipients
    (users + @department_emails)
  end

  def users
    User.internal.where(department_id: @department.id, sub_department_id: sub_departments).enabled
  end

  def sub_departments
    ids =  @ticket_department.ticket_department_sub_departments.with_deleted.pluck(:sub_department_id)

    ids.present? ? ids : nil
  end

  def subject(_user)
    I18n.t("shared.notifications.messages.referral.delete.subject.#{ticket_type}", protocol: @ticket.parent_protocol)
  end

  def body(_user)
    I18n.t("shared.notifications.messages.referral.delete.body.#{ticket_type}", user_name: @current_user.name,
      protocol: @ticket.parent_protocol)
  end

  def user_notificable?(_user)
    true
  end

  def send_mail?(_user)
    true
  end
end
