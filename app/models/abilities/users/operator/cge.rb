class Abilities::Users::Operator::Cge < Abilities::Users::Operator::Base

  def initialize(user)
    can_manage_stats_tickets
    can_manage_ticket_reports
    can_manage_solvability_reports
    can_manage_gross_exports
    can_show_protester_info
    can_manage_evaluation_exports

    can_manage_users(user)
    can_manage_tickets(user)
    can_manage_answers(user)
    can_manage_attendance_responses
    can_manage_comments
    can_manage_attachments(user)
    can_manage_answer_templates(user)

    can_letter_answer_option(user)
    can_phone_answer_option(user)
    denunciation_management(user)
    can_certificate(user)

    can_protect_ticket_attachments(user)

    can [:filter_by_organs_on_reports], Organ

    can_view_ticket_attendance_evaluation(user)

    can_manage_sou_evaluation_samples(user)

    can_manage_generated_list(user)

    super
  end

  private

  def can_manage_solvability_reports
    can :manage, SolvabilityReport
  end

  def can_manage_users(current_user)
    can_manage_itself(current_user)

    can [:index, :show], User
  end

  def can_manage_tickets(user)
    can [
      :create_ticket,
      :global_tickets_index,
      :immediate_answer,
      :unknown_classification,
      :create_public_comment,
      :view_public_comment
    ], Ticket

    can_create_and_search_tickets
    can_read_ticket(user)
    can_history_ticket(user)
    can_change_ticket_type(user)
    can_change_sou_type(user)
    can_view_deadline
    can_manage_ticket_invalidation(user)
    can_clone_ticket(user)
    can_manage_share_ticket(user)
    can_transfer_tickets(user)
    can_share_to_couvi_and_cosco
    can_appeal_ticket(user)
    can_reopen_ticket(user)
    can_attendance_evaluate_ticket(user)
    can_manage_ticket_classification(user)
    can_answer_ticket(user)
    can_view_ticket_user_info(user)
    can_view_ticket_user_password(user)
    can_manage_note(user)
    can_view_denunciation(user)
    can_email_reply(user)
  end

  def can_manage_answers(_)
    can :view, Answer

    can [:approve_answer, :reject_answer, :edit_answer], Answer do |answer|
      answer.awaiting? && answer.sectoral?
    end
  end

  def can_manage_attendance_responses
    can :show, AttendanceResponse
  end

  def can_manage_comments
    can :view, Comment
  end

  def can_manage_attachments(user)
    can :view, Attachment do |attachment|
      user.denunciation_tracking? ||
      !TicketProtectAttachment.where(
        attachment_id: attachment
      ).present?
    end

    can_destroy_attachment(user)
  end


  # Helpers

  #
  # Override Abilities::Base#user_requirements
  #
  def user_requeriments(_, _)
    true
  end

  def user_can_manage_ticket?(ticket, user)
    ticket.denunciation? ? user.denunciation_tracking? : true
  end


  ## Tickets

  def denunciation_management(user)
    can [:edit_denunciation_type], Ticket do |ticket|
      user.denunciation_tracking? &&
      ticket.denunciation? &&
      ticket.sou? &&
      ticket.open?
    end
  end

  def can_history_ticket(user)
    can :history, Ticket do |ticket|
      user_can_manage_ticket?(ticket, user)
    end
  end

  def can_change_sou_type(user)
    can :change_sou_type, Ticket do |ticket|
      user_can_manage_ticket?(ticket, user)
    end
  end

  def can_manage_ticket_invalidation(user)
    can_invalidate_ticket(user)
    can_approve_and_reject_invalidation(user)
  end

  def can_invalidate_ticket(_)
    can :invalidate, Ticket do |ticket|
      ticket.parent? && ticket.active?
    end
  end

  def can_approve_and_reject_invalidation(_)
    can [:approve_invalidation, :reject_invalidation], Ticket do |ticket|
      !ticket_log_invalidation_approved?(ticket)
    end
  end

  def ticket_log_invalidation_approved?(ticket)
    ticket.ticket_logs.invalidate.exists?(['data LIKE ?', "%status: :approved%"])
  end

  def can_manage_share_ticket(user)
    can_share_ticket(user)
    can_delete_share_ticket(user)
  end

  def ticket_able_to_share?(ticket)
    ticket.parent? &&
    ticket.active? &&
    !ticket.partial_answer?
  end

  def can_transfer_tickets(_)
    can :transfer_organ, Ticket do |ticket|
      ticket.open? &&
      ticket.child? &&
      check_denunciation_type(ticket) &&
      ticket.no_answers?
    end
  end

  def can_clone_ticket(_)
    can :clone_ticket, Ticket do |ticket|
      ticket.parent?
    end
  end

  def can_attendance_evaluate_ticket(_)
    can [:attendance_evaluate], Ticket do |ticket|
      ticket.no_children?
    end
  end

  def can_manage_public_comments(user)
    can_create_public_comment(user)
    can_view_public_comment
  end

  def can_manage_ticket_classification(user)
    can_classify_ticket(user)
    can_classify_without_organ_ticket
    can_classify_denunciation(user)
  end

  def can_classify_ticket(_)
    can :classify, Ticket do |ticket|
      (ticket.parent_no_active_children? || ticket.child?) && !ticket.rede_ouvir?
    end
  end

  def can_classify_denunciation(user)
    return unless user.operator_denunciation?

    can [:classify_denunciation], Ticket do |ticket|
      ticket.denunciation? &&
      !ticket.denunciation_type.nil? &&
      user_can_manage_ticket?(ticket, user) &&
      ticket.parent_no_active_children? &&
      ticket_able_to_share?(ticket)
    end
  end

  def can_answer_ticket(user)
    can :answer, Ticket do |ticket|
      ticket.elegible_to_answer?(user) &&
      (ticket.all_active_children_classified? || ticket.appeal?)
    end
  end

  def can_view_ticket_user_info(user)
    can :view_user_info, Ticket do |ticket|
      user_can_manage_ticket?(ticket, user) || ticket_created_by_user?(ticket, user) &&
      !ticket.hide_personal_info?
    end
  end

  def check_denunciation_type(ticket)
    (ticket.denunciation? && ticket.denunciation_type.present?) || !ticket.denunciation?
  end

  def can_share_to_couvi_and_cosco
    can :share_to_couvi, Ticket
    can :share_to_cosco, Ticket
  end

  def can_share_ticket(user)
    can :share, Ticket do |ticket|
      user_can_manage_ticket?(ticket, user) &&
      ticket_able_to_share?(ticket) &&
      check_denunciation_type(ticket) &&
      !ticket.reopened_without_organ?
    end
  end

  def can_certificate(_)
    can :can_certificate, Ticket do |ticket|
      !ticket.appeals?
    end
  end

  def can_protect_ticket_attachments(user)
    can :protect_attachment_on_share_with_organ, Ticket do |ticket|
      user.denunciation_tracking? && ticket.denunciation?
    end
  end

  ## Operator::SouEvaluationSamples

  def can_manage_sou_evaluation_samples(user)
    can :manage, Operator::SouEvaluationSample
  end

  # Operator::SouEvaluationSamples::GeneratedList

  def can_manage_generated_list(user)
    can :manage, Operator::SouEvaluationSamples::GeneratedList
  end

  def can_view_ticket_attendance_evaluation(user)
    can :view_ticket_attendance_evaluation, Ticket do |ticket|
      ticket.marked_internal_evaluation?
    end
  end

end
