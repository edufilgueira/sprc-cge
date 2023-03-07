#
# Serviço de notificação
#
class BaseNotifier
  include Rails.application.routes.url_helpers

  attr_reader :current_user, :ticket

  def call
    recipients.each do |user|
      send_notification(user) if user_notificable?(user)
    end
  end


  # private

  private

  def send_notification(user)
    Mailboxer::Notification.notify_all(
      user,
      subject(user),
      body(user),
      nil,
      true,
      nil,
      send_mail?(user)
    )
  end

  def send_mail?(user)
    anonymous_notificable?(user) || email_allowed?(user)
  end

  def user_notificable?(user)
    if user.is_a?(User)
      role = notification_role(user)
      (role == 'email' || role == 'system')
    else
      anonymous_notificable?(user)
    end
  end

  def anonymous_notificable?(user)
    user.is_a?(Ticket) && user.email.present?
  end

  def email_allowed?(user)
    notification_role(user) == 'email'
  end

  # o criador do ticket pode ser um cidadão sem perfil mas que forneceu o email
  # quando uma setorial cria uma chamado apenas o cidadão (email do ticket) recebe notificação
  def users_ticket_owner
    # verifica se ticket vinculado pertence a um cidadao (user_type = user)
    ticket_parent.created_by&.user? ? [ticket_parent.created_by] : [ticket_parent]
  end

  def cge
    denunciation = ticket.denunciation?

    User.cge.where(denunciation_tracking: denunciation).enabled
  end

  def ticket_children
    ticket_parent.tickets
  end

  def ticket_child(user)
    organ = user.organ
    subnet = user.subnet

    if subnet.present?
      ticket_children.find_by(subnet: subnet)
    elsif organ.present?
      ticket_children.find_by(organ: organ)
    end || ticket
  end

  def ticket_parent
    ticket.parent || ticket
  end

  def all_organs_involved
    ticket_children.map(&:organ)
  end

  def all_subnets_involved
    ticket_children.map(&:subnet)
  end

  def ticket_for_user(user)
    return ticket_parent if user.is_a?(Ticket)

    ticket_parent_for_user?(user) ? ticket_parent : ticket_child(user)
  end

  def ticket_parent_for_user?(user)
    (user.cge? || user.user? || user.call_center?)
  end

  def protocol_for_user(user)
    ticket_for_user(user).parent_protocol
  end

  def ticket_url(user)
    return ticket_url_for_call_center(user) if user.is_a?(User) && user.call_center?

    url_for([namespace(user), :ticket, id: ticket_for_user(user).id])
  end

  def ticket_url_for_call_center(user)
    url_for([namespace(user), :call_center_ticket, id: ticket_for_user(user).id])
  end

  def namespace(user)
    return :ticket_area if user.is_a?(Ticket)
    user.namespace
  end

  def user_type(user)
    return 'ticket' if user.is_a?(Ticket)
    user.user_type
  end

  def ticket_type
    ticket.ticket_type
  end

  def user_name
    current_user.name
  end

  def notification_role(user)
    class_name = self.class.name.underscore.split('/').last.to_sym
    user.notification_roles[class_name]
  end

end
