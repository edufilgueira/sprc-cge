class Abilities::Users::Operator::CallCenter < Abilities::Users::Operator::Base

  def initialize(user)
    can_manage_users(user)
    can_manage_tickets(user)
    can_manage_answers(user)
    can_manage_attendance_responses
    can_manage_comments
    can_manage_attachments(user)
    can_manage_answer_templates(user)
    can_phone_answer_option(user)

    super
  end

  private

  def can_manage_users(current_user)
    can_manage_itself(current_user)
  end

  def can_manage_tickets(user)

    can :global_tickets_index, Ticket

    can_create_and_search_tickets
    can_read_ticket(user)
    can_view_deadline

    can_appeal_ticket(user)
    can_reopen_ticket(user)

    can_manage_public_comment(user)
    can_view_ticket_user_info(user)
    can_view_ticket_user_password
    can_note_tickets(user)
    can_manage_denunciation(user)
    can_email_reply_tickets(user)

    can_delete_share_ticket(user)
  end

  def can_manage_answers(user)
    can :view, Answer

    can_evaluate_answers(user)
  end

  def can_manage_attendance_responses
    can [:show, :create], AttendanceResponse
  end

  def can_manage_comments
    can :view, Comment
  end

  def can_manage_attachments(user)
    can :view, Attachment

    can_destroy_attachment(user)
  end

  def can_manage_answer_templates(user)
    can :manage, AnswerTemplate do |answer_template|
      answer_template.user_id == user.id
    end
  end


  # Helpers

  #
  # Override Abilities::Base#user_requirements
  #
  def user_requeriments(_, _)
    true
  end


  ## Tickets

  def can_read_ticket(_)
    can [:read, :show, :history], Ticket
  end

  def can_manage_public_comment(_)
    can :view_public_comment, Ticket
  end

  def can_view_ticket_user_info(_)
    can :view_user_info, Ticket do |ticket|
      !ticket.hide_personal_info?
    end
  end

  def can_view_ticket_user_password
    can :view_user_password, Ticket
  end

  def can_note_tickets(_)
    can [:edit_note, :update_note], Ticket
  end

  def can_manage_denunciation(_)
    can [:view_denunciation, :edit_denunciation_organ], Ticket do |ticket|
      ticket.denunciation?
    end
  end

  def can_email_reply_tickets(_)
    can :email_reply, Ticket do |ticket|
      ticket_able_to_email_reply?(ticket)
    end
  end


  ## Answers

  def can_evaluate_answers(_)
    can :evaluate, Answer do |answer|
      !answer.user_evaluated? &&
      answer.final? &&
      answer.ticket.final_answer?
    end
  end
end
