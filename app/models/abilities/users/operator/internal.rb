class Abilities::Users::Operator::Internal < Abilities::Users::Operator::Base

  def initialize(user)
    can_manage_users(user)
    can_manage_tickets(user)
    can_manage_answers(user)
    can_manage_attendance_responses
    can_manage_comments
    can_manage_attachments(user)
    can_manage_answer_templates(user)

    can_letter_answer_option(user)
    can_phone_answer_option(user)

    super
  end

  private

  def can_manage_users(current_user)
    can_manage_itself(current_user)
  end

  def can_manage_tickets(user)
    can [:create_ticket, :unknown_classification], Ticket

    can_create_and_search_tickets
    can_read_ticket(user)
    can_history_ticket(user)
    can_view_deadline

    can_forward_ticket(user)
    can_manage_share_internal_area_ticket(user)
    can_transfer_department_ticket(user)

    can_classify_without_organ_ticket

    can_answer_ticket(user)
    can_view_ticket_user_info(user)
  end

  def can_manage_answers(user)
    can :view, Answer do |answer|
      !answer.department? || answer_belongs_to_department?(answer, user)
    end
  end

  def can_manage_attendance_responses
    can :show, AttendanceResponse
  end

  def can_manage_comments
    can :view, Comment
  end

  def can_manage_attachments(user)
    # Todo implementar filtro por departamento
    # não pode ver se tiver protegido p orgão ou departamento
    can :view, Attachment do |attachment|

      !(TicketProtectAttachment.where(
        attachment_id: attachment,
        resource_type: 'Ticket').present? ||

      TicketProtectAttachment.joins(join_tpa_td).where(
        attachment_id: attachment,
        resource_type: 'TicketDepartment',
        ticket_departments: {
          department_id: user.department_id
        }).present?)

    end

    can_destroy_attachment(user)
  end

  def can_manage_answer_templates(user)
    can :manage, AnswerTemplate do |answer_template|
      answer_template.user_id == user.id
    end
  end

  def can_read_ticket(user)
    can :read, Ticket do |ticket|
      if ticket.parent.present? and ticket.created_by.nil?
        ticket.created_by = ticket.parent.created_by
      end

      ticket.new_record? || user_can_read_ticket?(ticket, user) || ticket_created_by_user?(ticket, user)
    end
  end


  # Helpers

  #
  # Override Abilities::Base#user_requirements
  #
  def user_requeriments(ticket, user)
    ticket_created_by_user?(ticket, user)
  end

  def user_can_manage_ticket?(ticket, user)
    ticket.open? && user_can_read_ticket?(ticket, user)
  end

  def user_can_read_ticket?(ticket, user)
    ticket.ticket_department_by_user(user).present?
  end


  ## Tickets

  def can_forward_ticket(user)
    can :forward, Ticket do |ticket|
      user_can_manage_ticket?(ticket, user) &&
      within_forward_and_transfer_deadline?(ticket, user) &&
      without_awaiting_or_approved_positionings?(ticket, user)
    end
  end

  def within_forward_and_transfer_deadline?(ticket, user)
    ticket_department = ticket.ticket_department_by_user(user)
    ticket_department.present? &&
    #
    # estamos reaproveitando o mesmo método para compartilhamento (within_share_deadline?)
    # que define o prazo em que CGE pode encaminha o ticket definido em Ticket::CGE_SHARE_DEADLINE
    #
    Ticket.within_share_deadline?(ticket_department.created_at)
  end

  def without_awaiting_or_approved_positionings?(ticket, user)
    ! ticket.answers.by_department(user.department_id).exists?(status: [:awaiting, :sectoral_approved])
  end

  def can_transfer_department_ticket(user)
    can :transfer_department, TicketDepartment do |ticket_department|
      ticket = ticket_department.ticket

      user_can_manage_ticket?(ticket, user) &&
      user.department_id == ticket_department.department_id &&
      !ticket.rede_ouvir?
    end
  end

  def can_answer_ticket(user)
    can :answer, Ticket do |ticket|
      user_can_manage_ticket?(ticket, user) &&
      ticket.elegible_to_answer?(user) &&
      ticket_department_not_answered?(ticket, user)
    end
  end

  def can_view_ticket_user_info(user)
    can :view_user_info, Ticket do |ticket|
      ticket_created_by_user?(ticket, user) && !ticket.denunciation? &&
      !ticket.hide_personal_info?
    end
  end

  def ticket_department_not_answered?(ticket, user)
    ticket_department = ticket.ticket_department_by_user(user)
    ticket_department.present? && ticket_department.not_answered?
  end


  ## Answers

  def answer_belongs_to_department?(answer, user)
    answer.department? && answer.user_department == user.department
  end

  private

  def join_tpa_td
    'inner join ticket_departments on ticket_departments.id = resource_id'
  end
end
