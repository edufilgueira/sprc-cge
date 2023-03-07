class Abilities::Users::Operator::Chief < Abilities::Users::Operator::Base

  def initialize(user)
    can :read, :all

    can_manage_stats_tickets
    can_manage_ticket_reports
    can_manage_gross_exports
    can_manage_evaluation_exports

    can_manage_users(user)
    can_manage_tickets(user)
    can_manage_ticket_departments(user)
    can_manage_answers(user)
    can_manage_attendance_responses
    can_manage_comments
    can_manage_attachments(user)
    can_manage_answer_templates(user)

    can_letter_answer_option(user)
    can_phone_answer_option(user)
    can_view_organ_association(user)

    super
  end

  private

  def can_manage_users(current_user)
    can_manage_itself(current_user)
  end

  def can_manage_tickets(user)

    can [:create_ticket, :immediate_answer], Ticket

    can_create_and_search_tickets
    can_read_ticket(user)
    can_history_ticket(user)
    can_manage_ticket_extension(user)
    can_change_ticket_type(user)
    can_view_deadline
    can_forward_ticket(user)
    can_manage_share_ticket(user)
    can_transfer_ticket(user)

    can_appeal_ticket(user)
    can_reopen_ticket(user)

    can_change_sou_type(user)
    can_manage_public_comment(user)

    can_classify_ticket(user)
    can_classify_without_organ_ticket

    can_view_ticket_user_info(user)
  end

  def can_manage_ticket_departments(user)
    can [:edit, :update, :poke], TicketDepartment do |ticket_department|
      ticket_department.ticket.active? && resource_organ_eql?(ticket_department.ticket, user)
    end
  end

  def can_manage_answers(user)
    can :view, Answer

    can_change_answer_certificate(user)
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


  # Helpers

  #
  # Override Abilities::Base#user_requirements
  #
  def user_requeriments(ticket, user)
    ticket_created_by_user?(ticket, user)
  end

  def user_can_manage_ticket?(ticket, user)
    resource_organ_eql?(ticket, user)
  end


  ## Tickets

  def can_manage_ticket_extension(user)
    can_approve_or_reject_extension(user)
    can_extend_ticket_second_time(user)
    can_cancel_second_extend(user)
  end

  def can_approve_or_reject_extension(user)
    can [:approve_extension, :reject_extension], Ticket do |ticket|
      ticket.active? && ticket.elegible_to_approve_extension? && user.organ == ticket.organ
    end
  end

  def can_manage_public_comment(_)
    can :view_public_comment, Ticket
  end

  def can_extend_ticket_second_time(user)
    can :second_extend, Ticket do |ticket|
      user_can_manage_ticket?(ticket, user) &&
      ticket.open? &&
      ticket.sou? &&
      ticket.elegible_organ_to_second_extension? &&
      ticket.extended? &&
      !ticket.expired? &&
      !ticket.extended_second_time
    end
  end

  def can_cancel_second_extend(user)
    can :cancel_second_extend, Ticket do |ticket|
      user_can_manage_ticket?(ticket, user) &&
      ticket.open? &&
      ticket.sou? &&
      ticket.elegible_organ_to_approve_reject_or_cancel_second_extension?
    end
  end

  def can_view_organ_association(user)
    can :view_organ_association, User if user.chief?
  end

  ## Answers

  def can_change_answer_certificate(_)
    can :change_answer_certificate, Answer do |answer|
      answer.ticket_sic?
    end
  end
end
