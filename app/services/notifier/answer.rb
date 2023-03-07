#
# Serviço de notificação de comentários do tipo resposta
#
class Notifier::Answer < BaseNotifier
  include ActionView::Helpers::TextHelper 

  attr_reader :answer

  def self.call(answer_id, current_user_id = nil)
    new(answer_id, current_user_id).call
  end

  def initialize(answer_id, current_user_id)
    @current_user = User.find(current_user_id) if current_user_id.present?
    @answer = ::Answer.find(answer_id)
    @ticket = answer.ticket
  end


  # private

  private

  def recipients
    case answer.status
    when 'awaiting'
      answer_awaiting_recipient
    when 'sectoral_rejected'
      ticket.subnet? ? subnets : internals
    when 'sectoral_approved', 'subnet_approved', 'subnet_rejected'
      internals
    when 'cge_approved'
      users
    when 'cge_rejected'
      ticket.subnet? ? subnets : sectorals
    else
      []
    end
  end

  def answer_awaiting_recipient
    case answer.answer_scope
    when 'department', 'subnet'
      sectorals
    when 'sectoral'
      cge
    when 'subnet_department'
      subnets
    else
      []
    end
  end

  def users
    users_ticket_owner
  end

  def subnets
    User.subnet_sectoral.from_subnet(ticket.subnet).enabled
  end

  def sectorals
    User.sectorals_from_organ_and_type(ticket.organ, ticket_type).enabled
  end

  def internals
    return [] if department_id.blank?
    User.internal.where(department: department_id, sub_department_id: sub_department_id).enabled
  end

  def department_id
    answer.ticket_log.data[:responsible_department_id]
  end

  def sub_department_id
    ids = ticket_department&.ticket_department_sub_departments&.pluck(:sub_department_id)

    ids.present? ? ids : nil
  end

  def ticket_department
    ticket.ticket_departments.find_by(department_id: department_id)
  end

  def ticket_type
    ticket.ticket_type
  end

  def subject(user)
    namespace = namespace(user)
    answer_status = answer.status
    protocol = protocol_for_user(user)

    I18n.t("shared.notifications.messages.answer.#{namespace}.#{answer_status}.subject.#{ticket_type}", protocol: protocol)
  end


  def body(user)
    answer_status = answer.status
    answer_description = truncate(answer.description, length: 27000, escape: false)
    namespace = namespace(user)
    protocol = protocol_for_user(user)
    user_name = current_user&.name

    I18n.t("shared.notifications.messages.answer.#{namespace}.#{answer_status}.body.#{ticket_type}", user_name: user_name, protocol: protocol, url: ticket_url(user), answer_description: answer_description)
  end
end
