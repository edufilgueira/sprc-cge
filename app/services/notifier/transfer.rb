class Notifier::Transfer < BaseNotifier

  attr_reader :ticket_department

  def self.call(ticket_id, current_user_id = nil, ticket_department_id = nil)
    new(ticket_id, current_user_id, ticket_department_id).call
  end

  def initialize(ticket_id, current_user_id, ticket_department_id)
    @current_user = User.find(current_user_id) if current_user_id.present?
    @ticket_department = TicketDepartment.find(ticket_department_id) if ticket_department_id.present?
    @ticket = Ticket.find(ticket_id)
  end


  # private

  private

  def recipients
    (operators + users_ticket_owner).uniq
  end

  def operators
    current_user.internal? ? internals : sectorals
  end

  def sectorals
    if ticket_subnet.present?
      User.subnet_sectoral.from_subnet(ticket.subnet).enabled
    else
      User.sectorals_from_organ_and_type(ticket_organ, ticket_type).enabled
    end
  end

  def internals
    User.internal.where(department: department, sub_department: sub_departments).enabled
  end

  def department
    ticket_department.department
  end

  def sub_departments
    ids =  ticket_department.ticket_department_sub_departments.pluck(:sub_department_id)

    ids.present? ? ids : nil
  end

  def subject(user)
    namespace = namespace(user)
    I18n.t("shared.notifications.messages.transfer.#{namespace}.subject.#{ticket_type}", protocol: protocol_for_user(user))
  end

  def organ_or_department
    if current_user.internal?
      department.title
    elsif ticket_subnet.present?
      ticket_subnet.title
    else
     ticket_organ.title
    end
  end

  def ticket_organ
    ticket.organ
  end

  def ticket_subnet
    ticket.subnet
  end

  def body(user)
    namespace = namespace(user)

    I18n.t("shared.notifications.messages.transfer.#{namespace}.body.#{ticket_type}",
      user_name: user_name, protocol: protocol_for_user(user), organ_name: organ_or_department, url: ticket_url(user))
  end
end
