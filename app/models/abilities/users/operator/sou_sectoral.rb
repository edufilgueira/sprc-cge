class Abilities::Users::Operator::SouSectoral < Abilities::Users::Operator::Base

  def initialize(user)
    can_manage_stats_tickets(user)
    can_manage_ticket_reports
    can_manage_gross_exports
    can_manage_evaluation_exports(user)

    can_manage_users(user)
    can_manage_tickets(user)
    can_manage_ticket_departments(user)
    can_manage_departments(user)
    can_manage_answers(user)
    can_manage_attendance_responses
    can_manage_comments
    can_manage_attachments(user)
    can_manage_answer_templates(user)
    can_view_topics(user)

    can_letter_answer_option(user)
    can_phone_answer_option(user)

    can_protect_ticket_attachments(user)

    can_certificate(user)

    super
  end

  private

  def can_manage_evaluation_exports(user)
    can :create, EvaluationExport do |evaluation_export|
      evaluation_export.ticket_type_filter == 'sou' || user.acts_as_sic?
    end
  end

  def can_manage_stats_tickets(user)
    can :index, Stats::Ticket

    can :create, Stats::Ticket do |stats|
      stats_not_started?(stats) &&
      (stats.organ.blank? || stats_organ_eql?(stats, user))
    end
  end

  def can_manage_users(current_user)
    can_manage_itself(current_user)

    can [:new], User

    can_create_or_view_users(current_user)
    can_update_users(current_user)
  end

  def can_manage_tickets(user)

    can [
      :create,
      :search,
      :create_ticket,
      :global_tickets_index,
      :immediate_answer,
      :unknown_classification
    ], Ticket

    can_read_ticket(user)
    can_update_ticket(user)
    can_history_ticket(user)
    can_manage_ticket_extension(user)
    can_change_ticket_type(user)
    can_change_sou_type(user)
    can_view_deadline
    can_invalidate_ticket(user)
    can_clone_ticket(user)
    can_forward_ticket(user)
    can_manage_share_ticket(user)
    can_manage_share_internal_area_ticket(user)
    can_transfer_ticket(user)
    can_share_to_couvi(user)

    can_appeal_ticket(user)
    can_reopen_ticket(user)

    can_manage_public_comment(user)

    can_classify_ticket(user)
    can_classify_without_organ_ticket

    can_answer_ticket(user)
    can_view_ticket_user_info(user)
    can_view_ticket_user_password(user)
    can_create_positioning(user)
    can_email_reply(user)
  end

  def can_share_ticket(user)
    can :share, Ticket do |ticket|
      user_can_manage_ticket?(ticket, user) && ticket_able_to_share?(ticket)
    end
  end

  def can_transfer_ticket(user)
    can :transfer_organ, Ticket do |ticket|
      user_can_manage_ticket?(ticket, user) &&
      ticket_able_to_transfer?(ticket) &&
      ticket.no_answers?
    end
  end

  def can_share_to_couvi(user)
    if user.organ.present? && user.organ.cge?
      can :share_to_couvi, Ticket
    end
  end

  def ticket_able_to_transfer?(ticket)
    ticket.open? &&
    ticket.ticket_departments.blank? &&
    !ticket.rede_ouvir? &&
    (
      Ticket.within_share_deadline?(ticket.confirmed_at) ||
      ticket.organ.subnet?
    )
  end

  def ticket_able_to_share?(ticket)
    ticket.open? &&
    !ticket.partial_answer? &&
    !ticket.rede_ouvir? &&
    (
      Ticket.within_share_deadline?(ticket.confirmed_at) ||
      ticket.organ.subnet?
    ) &&
    !ticket.reopened_without_organ?
  end

  def can_manage_ticket_departments(user)
    can [:edit, :update, :poke], TicketDepartment do |ticket_department|
      ticket_department.ticket.active? && resource_organ_eql?(ticket_department.ticket, user)
    end

    can [:renew_referral], TicketDepartment do |ticket_department|
      ticket = ticket_department.ticket
      ticket.reopened > 0  && ticket.sectoral_attendance?
    end
  end

  def can_manage_departments(user)
    can :manage, Department

    can [:subnet_index, :subnet_show], Department if user.organ_subnet?

    can [:read, :update, :destroy], Department do |department|
      department.organ == user.organ
    end
  end

  def can_manage_answers(user)
    can :view, Answer
    can_approve_and_reject_answer(user)
    can_edit_answer(user)

    can_change_answer_certificate(user)
  end

  def can_manage_attendance_responses
    can :show, AttendanceResponse
  end

  def can_manage_comments
    can :view, Comment
  end

  def can_manage_attachments(user)
     # não pode ver se tiver protegido p orgão
    can :view, Attachment do |attachment|
      !TicketProtectAttachment.joins(join_tpa_t).where(
        attachment_id: attachment,
        resource_type: 'Ticket',
        tickets: { organ_id: user.organ }
      ).present?
    end

    can_destroy_attachment(user)
  end


  # Helpers

  #
  # Override Abilities::Base#user_requirements
  #
  def user_requeriments(ticket, user)
    ticket_created_by_user?(ticket, user) ||
    resource_organ_eql?(ticket, user)
  end

  def user_can_manage_ticket?(ticket, user)
    (ticket.sou? || user.acts_as_sic?) && resource_organ_eql?(ticket, user) && user_can_manage_denunciation?(ticket, user)
  end

  def user_can_manage_denunciation?(ticket, user)
    ticket.denunciation? ? user.sectoral_denunciation? : true
  end

  def stats_organ_eql?(stats, user)
    stats.organ_id == user.organ_id
  end

  ## Users

  def can_create_or_view_users(current_user)
    can [:create, :index, :show], User do |user|
      user_organ =
        case user.operator_type
        when 'sou_sectoral', 'sic_sectoral', 'internal'
          user.organ
        when 'subnet_sectoral'
          user.subnet.organ
        end

      current_user.organ == user_organ
    end
  end

  def can_update_users(current_user)
    can [:read, :update, :toggle_disabled], User do |user|
      same_organ = user.organ_id == current_user.organ_id
      same_organ && (user.internal? || user.subnet_sectoral?)
    end
  end

  ## Tickets

  def can_update_ticket(user)
    can [:edit, :update], Ticket do |ticket|
      ticket.open? && user_can_manage_ticket?(ticket, user)
    end
  end

  def can_manage_ticket_extension(user)
    can_extend_ticket(user)
    can_cancel_extend(user)
  end

  def can_extend_ticket(user)
    can :extend, Ticket do |ticket|
      user_can_manage_ticket?(ticket, user) &&
      ticket.open? &&
      ticket.elegible_organ_to_extension? &&
      ticket.can_extend_deadline?
    end
  end

  def can_cancel_extend(user)
    can :cancel_extend, Ticket do |ticket|
      user_can_manage_ticket?(ticket, user) &&
      ticket.elegible_organ_to_cancel_extension?
    end
  end

  def can_invalidate_ticket(user)
    can :invalidate, Ticket do |ticket|
      user_can_manage_ticket?(ticket, user) &&
      ticket.active? &&
      ticket_log_status_elegible_to_invalidate(ticket)
    end
  end

def ticket_log_status_elegible_to_invalidate(ticket)
    status_blocked = [:waiting, :approved]

    return true if (ticket.parent? || ticket.ticket_logs.invalidate.empty?)
    status_blocked.exclude?(ticket.ticket_logs.max.data[:status])
end

  def can_manage_public_comment(user)
    can :view_public_comment, Ticket

    can :create_public_comment, Ticket do |ticket|
      user_can_manage_ticket?(ticket, user) &&
      ticket.open?
    end
  end

  def can_answer_ticket(user)
    can :answer, Ticket do |ticket|
      user_can_manage_ticket?(ticket, user) &&
      (ticket.elegible_to_answer?(user) || ticket.appeal?)
    end
  end

  def can_create_positioning(user)
    return unless user.positioning?

    can :create_positioning, Ticket do |ticket|
      user_can_manage_ticket?(ticket, user) &&
      ticket.ticket_departments.exists?(answer: :not_answered)
    end
  end


  ## Answers

  def can_approve_and_reject_answer(_)
    can [:approve_answer, :reject_answer], Answer do |answer|
      answer.awaiting? && (answer.department? || answer.subnet?)
    end
  end

  def can_edit_answer(_)
    can [:edit_answer], Answer do |answer|
      answer.awaiting? && answer.subnet?
    end
  end

  def can_change_answer_certificate(user)
    return unless user.acts_as_sic?
    can :change_answer_certificate, Answer do |answer|
      answer.ticket_sic?
    end
  end

  def can_protect_ticket_attachments(user)
    can :protect_attachment_on_share_with_organ, Ticket do |ticket|
      user.sectoral_denunciation && ticket.denunciation?
    end
  end

  ## Topics

  def can_view_topics(user)
    can :view, Topic do |topics|
      topics
    end
  end

  private

  def join_tpa_t
    'inner join tickets on tickets.id = resource_id'
  end
 
  def can_certificate(_)
    can :can_certificate, Ticket do |ticket|
      !ticket.appeals?
    end
  end
end