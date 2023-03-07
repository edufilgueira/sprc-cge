#
# Ability base herdado por abilities específicos:
#
# As permissões estão definidas em cada ability específico:
#
# Abilities::User: definição de permissões para usuário logado na plataforma;
#
# Abilities::Ticket: definição de permissões para usuário do tipo 'protocolo';
#

class Abilities::Base
  include CanCan::Ability

  APPEALS_LIMIT = 2

  private

  def can_evaluate(current_resource)
    can :evaluate, Answer do |answer|
      !answer.user_evaluated? &&
      answer.final? &&
      answer.ticket.final_answer? &&

      user_ticket_owner?(current_resource, answer.ticket)
    end
  end

  def can_appeal_ticket(resource)
    can :appeal, Ticket do |ticket|
      ticket.final_answer? &&
      ticket.sic? &&
      user_requeriments(ticket, resource) &&
      on_time_ticket(ticket) &&
      ticket_not_appealed?(ticket)  &&
      !reached_appeal_limit(ticket) &&
      ticket.parent?
    end
  end

  def can_reopen_ticket(resource)
    can :reopen, Ticket do |ticket|
      ticket.final_answer? &&
      user_requeriments(ticket, resource) &&
      ticket.responded_at? &&
      ticket_not_reopened?(ticket) &&
      parent_not_appealed?(ticket) &&
      organ_disabled?(ticket) &&
      !(ticket.reopened? && ticket.sou?)
    end
  end

  def can_view_answer
    can :view, Answer do |answer|
      %w( call_center_approved cge_approved user_evaluated ).include?(answer.status)
    end
  end

  def can_create_public_comment
    can :create_public_comment, Ticket do |ticket|
      !ticket.final_answer?
    end
  end

  def can_view_deadline
    can :can_view_deadline, Ticket do |ticket|
      ticket.active? && !ticket.partial_answer?
    end
  end

  def can_view_comment(resource)
    can [:view], Comment do |comment|
      case resource.class.to_s
      when 'User'
        resource.operator? || comment.external?
      when 'Ticket'
        comment.author_id == resource.id && comment.external?
      end
    end
  end

  def can_view_attachment(resource)
    can [:view], Attachment do |attachment|
      attachmentable = attachment.attachmentable
      case attachmentable.class.to_s
      when 'Comment', 'Answer'
        can? :view, attachment.attachmentable
      when 'Ticket'
        resource.try(:operator?) ||
        attachmentable.created_by_id == resource.id ||
        ticket_resource?(attachmentable, resource)
      end
    end
  end

  def can_destroy_attachment(resource)
    can [:destroy], Attachment do |attachment|
      attachment_owner_id(attachment) == resource.id ||
      ticket_resource?(attachment.attachmentable, resource)
    end
  end

  def ticket_resource?(ticket, resource)
    resource.is_a?(Ticket) && ticket.id == resource.id
  end

  def ticket_not_reopened?(ticket)
    ticket.reopened_at.blank? || ticket.responded_at > ticket.reopened_at
  end

  def ticket_not_appealed?(ticket)
    ticket.appeals_at.blank? || ticket.responded_at > ticket.appeals_at
  end

  def parent_not_appealed?(ticket)
    (ticket.parent || ticket).appeals == 0
  end

  def on_time_ticket(ticket)
    ticket.responded_at.present? && ticket.responded_at > 10.days.ago
  end

  def reached_appeal_limit(ticket)
    ticket.appeals >= APPEALS_LIMIT
  end

  def user_requeriments(ticket, user)
    ticket_belongs_to_resource(ticket, user)
  end

  def attachment_owner_id(attachment)
    attachmentable = attachment.attachmentable
    case attachmentable.class.to_s
    when 'Comment'
      attachmentable.author_id
    when 'Answer'
      attachmentable.user_id
    when 'Ticket'
      attachmentable.created_by_id
    end
  end

  def organ_disabled?(ticket)
    ticket.organ_disabled_at.blank?
  end

  def ticket_created_by_user?(ticket, user)
    ticket.created_by == user
  end

  def can_view_ticket_user_print_password(user)
    can :view_user_print_password, Ticket do |ticket|
      ticket_created_by_user?(ticket, user)
    end
  end

  def can_reopen_ticket_with_immediate_answer(user)
    can :reopen_ticket_with_immediate_answer, Ticket do |ticket|
      !ticket.immediate_answer?
    end
  end
end
