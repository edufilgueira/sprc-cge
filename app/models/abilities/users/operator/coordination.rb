class Abilities::Users::Operator::Coordination < Abilities::Users::Operator::Base

  def initialize(user)
    can_manage_ticket_reports
    can_manage_stats_tickets
    can_manage_gross_exports
    can_show_protester_info
    can_manage_solvability_reports
    can_manage_evaluation_exports
    can_manage_ticket_departments(user)
    can_manage_users(user)
    can_manage_tickets(user)
    can_manage_answers(user)
    can_manage_attendance_responses
    can_manage_comments
    can_manage_attachments(user)
    can_manage_answer_templates(user)
    can_letter_answer_option
    can_protect_ticket_attachments(user)
    can_manage_sou_evaluation_samples(user)
    can_manage_generated_list(user)
    can_view_ticket_attendance_evaluation(user)

    can [:filter_by_organs_on_reports], Organ

    super
  end

  private

  def can_manage_evaluation_exports
    can :create, EvaluationExport
  end

  def can_manage_stats_tickets
    can :index, Stats::Ticket

    can :create, Stats::Ticket do |stats|
      stats_not_started?(stats)
    end
  end

  def can_manage_solvability_reports
    can :manage, SolvabilityReport
  end

  def can_manage_users(current_user)
    can_manage_itself(current_user)
  end

  def can_manage_tickets(user)
    can [
      :read,
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
    can_change_ticket_type(user)
    can_change_sou_type(user)
    can_view_deadline
    can_approve_or_reject_second_extension
    can_manage_ticket_invalidation(user)
    can_clone_ticket(user)
    can_forward_ticket(user)
    can_manage_share_ticket(user)
    can_manage_share_internal_area_ticket(user)
    can_transfer_ticket(user)
    can_share_to_couvi_and_cosco
    can_reopen_ticket(user)
    can_manage_public_comment(user)
    can_attendance_evaluate_ticket
    can_manage_ticket_classification(user)
    can_answer_ticket(user)
    can_view_ticket_user_info(user)
    can_view_ticket_user_password(user)
    can_manage_note(user)
    can_view_denunciation(user)
    can_email_reply(user)
    can_create_positioning(user)
    denunciation_management
  end

  def can_manage_ticket_invalidation(user)
    can_invalidate_ticket(user)
    can_approve_and_reject_invalidation(user)
  end

  def can_approve_and_reject_invalidation(user)
    can [:approve_invalidation, :reject_invalidation], Ticket do |ticket|
      !ticket_log_invalidation_approved?(ticket)
    end
  end

  def ticket_log_invalidation_approved?(ticket)
    ticket.ticket_logs.invalidate.exists?(['data LIKE ?', "%status: :approved%"])
  end

  def can_attendance_evaluate_ticket
    can [:attendance_evaluate], Ticket do |ticket|
      ticket.no_children?
    end
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
    can [:classify_denunciation], Ticket do |ticket|
      ticket.denunciation? &&
      !ticket.denunciation_type.nil? &&
      user_can_manage_ticket?(ticket, user) &&
      ticket.parent_no_active_children? &&
      ticket_able_to_share?(ticket)
    end
  end

  def can_manage_share_ticket(user)
    can_share_ticket(user)
    can_delete_share_ticket(user)
  end

  def can_manage_ticket_departments(user)
    can [:edit, :update, :poke], TicketDepartment do |ticket_department|
      ticket_department.ticket.active? && ticket_department.ticket.sou?
    end

    can [:renew_referral], TicketDepartment do |ticket_department|
      ticket = ticket_department.ticket
      ticket.reopened > 0  && ticket.sectoral_attendance?
    end
  end

  def ticket_able_to_share?(ticket)
    ticket.active? &&
    !ticket.partial_answer?
  end

  def user_can_manage_ticket?(ticket, user)
    ticket.sou?
  end

  def can_transfer_ticket(user)
    can :transfer_organ, Ticket do |ticket|
      ticket.open? &&
      ticket.child? &&
      check_denunciation_type(ticket) &&
      ticket.no_answers?
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

  def can_manage_answers(user)
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
    can :view, Attachment

    can_destroy_attachment(user)
  end

  def can_reopen_ticket(resource)
    can :reopen, Ticket do |ticket|
      ticket.final_answer? &&
      ticket.responded_at? &&
      ticket_not_reopened?(ticket) &&
      parent_not_appealed?(ticket) &&
      organ_disabled?(ticket) &&
      !(ticket.reopened? && ticket.sou?)
    end
  end

  # Helpers

  def user_can_manage_denunciation?(ticket, user)
    ticket.denunciation? ? user.sectoral_denunciation? : true
  end

  ## Tickets

  def denunciation_management
    can [:edit_denunciation_type], Ticket do |ticket|
      ticket.denunciation? &&
      ticket.sou? &&
      (
        (!ticket.parent?) ||
        (ticket.parent? && ticket.no_children?)
      )
    end
  end

  def can_approve_or_reject_second_extension
    can [:approve_extension, :reject_extension], Ticket do |ticket|
      ticket.active? &&
      ticket.sou? &&
      ticket.elegible_organ_to_approve_reject_or_cancel_second_extension?
    end
  end

  def can_update_ticket(user)
    can [:edit, :update], Ticket do |ticket|
      ticket.open? && ticket.sou?
    end
  end

  def can_approve_or_reject_second_extension
    can [:approve_extension, :reject_extension], Ticket do |ticket|
      ticket.active? &&
      ticket.sou? &&
      ticket.elegible_organ_to_approve_reject_or_cancel_second_extension?
    end
  end

  def can_invalidate_ticket(user)
    can :invalidate, Ticket do |ticket|
      ticket.active? &&
      ticket.sou? &&
      ticket_log_status_elegible_to_invalidate(ticket)
    end
  end

  def ticket_log_status_elegible_to_invalidate(ticket)
    return true if ticket.parent?

    statuses_blocked = [
      '%status: :approved%',
      '%status: :waiting%'
    ]

    !ticket.ticket_logs.invalidate.exists?(['data LIKE ? OR data like ?', statuses_blocked[0], statuses_blocked[1]])
  end

  def can_manage_public_comment(user)
    can :view_public_comment, Ticket

    can :create_public_comment, Ticket do |ticket|
      ticket.open?
    end
  end

  def can_answer_ticket(user)
    can :answer, Ticket do |ticket|
      ticket.open?
      ticket.elegible_to_answer?(user)
    end
  end

  def can_create_positioning(user)
    return unless user.positioning?

    can :create_positioning, Ticket do |ticket|
      ticket.open?
      ticket.ticket_departments.exists?(answer: :not_answered)
    end
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

  def can_manage_share_internal_area_ticket(user)
    can :share_internal_area, Ticket do |ticket|
      ticket.sou? &&
      ticket.open? &&
      !ticket.rede_ouvir? &&
      !ticket.parent? &&
      ticket.cge?
    end
  end

  def check_denunciation_type(ticket)
    (ticket.denunciation? && ticket.denunciation_type.present?) || !ticket.denunciation?
  end

  ## Answers

  def can_letter_answer_option
    can :answer_by_letter, User
  end

  def can_protect_ticket_attachments(user)
    can :protect_attachment_on_share_with_organ, Ticket do |ticket|
      ticket.denunciation?
    end
  end

  ## Operator::SouEvaluationSamples

  def can_manage_sou_evaluation_samples(user)
    can :manage, Operator::SouEvaluationSample
  end

  ## Operator::SouEvaluationSamples::GeneratedList

  def can_manage_generated_list(user)
    can :manage, Operator::SouEvaluationSamples::GeneratedList
  end

  def can_view_ticket_attendance_evaluation(user)
    can :view_ticket_attendance_evaluation, Ticket do |ticket|
      ticket.marked_internal_evaluation?
    end
  end
end
