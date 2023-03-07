class Notifier::Deadline < BaseNotifier

  # consts

  DEADLINES_NOTIFICABLE = [5, 1, 0, -1, -5, -10, -15, -20, -30]

  STATUS_SECTORAL_NOTIFICABLE = %w[
    sectoral_attendance
    internal_attendance
    sectoral_validation
  ]

  STATUS_INTERNAL_NOTIFICABLE = %w[
    internal_attendance
  ]


  # public

  def self.call(ticket_id)
    new(ticket_id).call
  end

  def initialize(ticket_id)
    @ticket = Ticket.find(ticket_id)
  end


  # private

  private

  def recipients
    operators + user_or_ticket
  end

  def operators
    cge + sectorals + internals
  end

  def cge
    return [] unless cge_notificable?

    super
  end

  def sectorals
    return [] unless sectoral_notificable?
    User.sectorals_from_organ_and_type(organ, ticket_type).enabled
  end

  def internals
    return [] unless internal_notificable?
    departments + sub_departments
  end

  def departments
    department_ids.present? ? User.enabled.internal.where(department_id: department_ids, sub_department_id: nil) : []
  end

  def sub_departments
    sub_department_ids.present? ? User.enabled.internal.where(sub_department_id: sub_department_ids) : []
  end

  def department_ids
    ticket_departments.left_joins(:ticket_department_sub_departments).where(ticket_department_sub_departments: { id: nil }).pluck(:department_id)
  end

  def sub_department_ids
    ticket_departments.joins(:ticket_department_sub_departments).pluck('ticket_department_sub_departments.sub_department_id')
  end

  def ticket_departments
    ticket.ticket_departments.not_answered.where(deadline: DEADLINES_NOTIFICABLE)
  end

  def sectoral_notificable?
    organ.present? &&
    STATUS_SECTORAL_NOTIFICABLE.include?(ticket.internal_status) &&
    DEADLINES_NOTIFICABLE.include?(user_deadline)
  end

  def internal_notificable?
    organ.present? &&
    STATUS_INTERNAL_NOTIFICABLE.include?(ticket.internal_status)
  end

  def user_or_ticket_notificable?
    ticket.parent? && DEADLINES_NOTIFICABLE.include?(user_deadline)
  end

  def cge_notificable?
    user_or_ticket_notificable?
  end

  def organ
    ticket.organ
  end

  def user_or_ticket
    return [] unless user_or_ticket_notificable?
    users_ticket_owner
  end

  def user_deadline
    ticket.deadline
  end

  def internal_deadline(user)
    department(user).deadline
  end

  def final_deadline(user)
    return internal_deadline(user) if user.try(:internal?)
    user_deadline
  end

  def modularized_deadline(user)
    final_deadline(user).abs
  end

  def department(user)
    ticket_departments.find_by(department_id: user.department_id)
  end

  def late_or_in_time(user)
    final_deadline(user) < 0 ? :late : :in_time
  end

  def subject(user)
    late_or_in_time = late_or_in_time(user)
    protocol = protocol_for_user(user)

    I18n.t("shared.notifications.messages.deadline.#{late_or_in_time}.subject", protocol: protocol)
  end

  def body(user)
    deadline = modularized_deadline(user)
    late_or_in_time = late_or_in_time(user)
    url = ticket_url(user)
    protocol = protocol_for_user(user)

    I18n.t("shared.notifications.messages.deadline.#{late_or_in_time}.body",
      deadline: deadline, protocol: protocol, url: url)
  end
end
