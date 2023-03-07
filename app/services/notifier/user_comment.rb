#
# Serviço de notificação de comentários com o cidadão
#
class Notifier::UserComment < BaseNotifier

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
    return [] unless comment.external?

    (users_ticket_owner + cge + sectorals + subnets - [author]).uniq
  end

  def subnets
    return [] unless all_subnets_involved.present?

    User.subnet_sectoral.from_subnet(all_subnets_involved)
  end

  def sectorals
    User.sectorals_from_organ_and_type(all_organs_involved, ticket_type).enabled
  end

  def author
    current_user || comment.ticket_log.responsible
  end

  def subject(user)
    protocol = protocol_for_user(user)
    namespace = namespace(user)

    I18n.t("shared.notifications.messages.user_comment.#{namespace}.subject.#{ticket_type}", protocol: protocol)
  end

  def body(user)
    protocol = protocol_for_user(user)
    user_name = author.as_author
    namespace = namespace(user)

    I18n.t("shared.notifications.messages.user_comment.#{namespace}.body.#{ticket_type}", user_name: user_name, protocol: protocol, url: ticket_url(user))
  end
end
