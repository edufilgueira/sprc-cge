#
# Serviço de notificação de comentários internos
#
class Notifier::InternalComment < BaseNotifier

  attr_reader :comment

  def self.call(comment_id, current_user_id = nil)
    new(comment_id, current_user_id).call
  end

  def initialize(comment_id, current_user_id = nil)
    @current_user = User.find(current_user_id) if current_user_id.present?
    @comment = Comment.find(comment_id)
    @ticket = comment.commentable
  end


  # privates

  private

  def recipients
    return [] unless comment.internal?

    # todos os operadores envolvidos recebem exceto o owner do comentário
    (cge + sectorals + internals + subnets - [author]).uniq
  end

  def sectorals
    User.sectorals_from_organ_and_type(all_organs_involved, ticket_type).enabled
  end

  def subnets
    return [] unless ticket.subnet.present?
    User.subnet_sectoral.from_subnet(ticket.subnet).enabled
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
    TicketDepartment.where(ticket_id: ticket_parent.tickets)
  end

  def department_ids
    ticket_departments.left_joins(:ticket_department_sub_departments).where(ticket_department_sub_departments: { id: nil }).pluck(:department_id)
  end

  def sub_department_ids
    ticket_departments.joins(:ticket_department_sub_departments).pluck('ticket_department_sub_departments.sub_department_id')
  end

  def author
    current_user || comment.ticket_log.responsible
  end

  def subject(user)
    protocol = protocol_for_user(user)

    I18n.t("shared.notifications.messages.internal_comment.subject", protocol: protocol)
  end


  def body(user)
    protocol = protocol_for_user(user)
    user_name = author.name

    I18n.t("shared.notifications.messages.internal_comment.body.#{ticket_type}", user_name: user_name, protocol: protocol, url: ticket_url(user))
  end

end
