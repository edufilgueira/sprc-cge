#
# Serviço de notificação de respostas parciais
#
class Notifier::PartialAnswer < BaseNotifier

  attr_reader :organ

  def self.call(organ_id)
    new(organ_id).call
  end

  def initialize(organ_id)
    @organ = Organ.find(organ_id)
    @ticket_type = 'sou'
    @ticket_url = operator_tickets_url(ticket_type: @ticket_type, internal_status: :partial_answer)
  end

  def call
    recipients.each do |user|
      send_notification(user)
    end
  end


  # private

  private

  def recipients
    return [] unless tickets.present?

    sectorals + internals
  end

  def sectorals
    User.sectorals_from_organ_and_type(organ, @ticket_type)
  end

  def internals
    departments + sub_departments
  end

  def departments
    department_ids.present? ? User.enabled.internal.where(department_id: department_ids, sub_department_id: nil) : []
  end

  def sub_departments
    sub_department_ids.present? ? User.enabled.internal.where(sub_department_id: sub_department_ids) : []
  end

  def ticket_departments
    TicketDepartment.where(ticket_id: tickets)
  end

  def department_ids
    ticket_departments.left_joins(:ticket_department_sub_departments).where(ticket_department_sub_departments: { id: nil }).pluck(:department_id)
  end

  def sub_department_ids
    ticket_departments.joins(:ticket_department_sub_departments).pluck('ticket_department_sub_departments.sub_department_id')
  end

  def tickets
    organ.tickets.partial_answer.from_type(@ticket_type)
  end

  def send_mail?(_user)
    true
  end

  def subject(_user)
    I18n.t('shared.notifications.messages.partial_answer.subject')
  end


  def body(_user)
    I18n.t('shared.notifications.messages.partial_answer.body', url: @ticket_url)
  end
end
