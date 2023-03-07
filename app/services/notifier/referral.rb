class Notifier::Referral < BaseNotifier

  def self.call(ticket_id, department_id, current_user_id = nil)
    new(ticket_id, department_id, current_user_id).call
  end

  def initialize(ticket_id, department_id, current_user_id)
    @current_user = User.find(current_user_id) if current_user_id.present?
    @department = Department.find(department_id) if department_id.present?
    @ticket = Ticket.find(ticket_id)
  end


  # private

  private

  def recipients
    (internals + users_ticket_owner).uniq
  end

  def internals
    return User.none unless @department.present?

    User.internal.where(department_id: @department.id, sub_department_id: sub_departments).enabled
  end

  def sub_departments
    ids =  ticket_department&.ticket_department_sub_departments&.pluck(:sub_department_id)

    ids.present? ? ids : nil
  end

  def ticket_department
    ticket.ticket_departments.find_by(department: @department)
  end

  def subject(user)
    namespace = namespace(user)
    I18n.t("shared.notifications.messages.referral.#{namespace}.subject.#{ticket_type}", protocol: protocol_for_user(user))
  end

  def body(user)
    namespace = namespace(user)

    I18n.t("shared.notifications.messages.referral.#{namespace}.body.#{ticket_type}", body_locale_params(user))
  end

  def unit_title
    return @department.title if @department.present?
  end

  def considerations(user)
    return ticket_department.considerations if ticket_department.considerations.present?
    I18n.t("shared.notifications.messages.referral.#{namespace(user)}.considerations.empty")
  end

  def body_locale_params(user)
    {
      user_name: user_name,
      protocol: protocol_for_user(user),
      department_name: unit_title,
      url: ticket_url(user),
      considerations: considerations(user)
    }
  end
end
