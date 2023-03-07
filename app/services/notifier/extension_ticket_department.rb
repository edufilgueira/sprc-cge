class Notifier::ExtensionTicketDepartment < BaseNotifier

  attr_accessor :ticket_department

  def self.call(ticket_department_id, current_user_id)
    new(ticket_department_id, current_user_id).call
  end

  def initialize(ticket_department_id, current_user_id)
    @ticket_department = ::TicketDepartment.find(ticket_department_id)
    @current_user = User.find(current_user_id)
  end


  # privates

  private

  def recipients
    User.internal.enabled.where(department_id: department, sub_department_id: sub_departments)
  end

  def subject(_user)
    I18n.t('shared.notifications.messages.extension_ticket_department.subject',
      protocol: protocol)
  end

  def body(_user)
    I18n.t("shared.notifications.messages.extension_ticket_department.body.#{ticket_type}",
      url: ticket_url, deadline_ends_at: deadline_ends_at)
  end

  def ticket
    ticket_department.ticket
  end

  def ticket_type
    ticket.ticket_type
  end

  def protocol
    ticket.parent_protocol
  end

  def deadline_ends_at
    ticket_department.deadline_ends_at
  end

  def department
    ticket_department.department
  end

  def ticket_url
    operator_ticket_url(ticket)
  end

  def notification_role(user)
    user.notification_roles[:extension]
  end

  def sub_departments
    ids = ticket_department.ticket_department_sub_departments.pluck(:sub_department_id)

    ids.present? ? ids : nil
  end
end
