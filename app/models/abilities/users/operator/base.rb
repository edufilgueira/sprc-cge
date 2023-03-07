class Abilities::Users::Operator::Base < Abilities::Users::Base

  def initialize(user)
    # PPA
    can_manage_participant_profile
    can_prioritize_regional_strategy
    can_revision_problem_situation
    can_review_problem_situation(user)
    can_review_prioritization(user)
    can_view_answer_type(user)
    can_view_answer_type_label(user)
    can_reopen_ticket_with_immediate_answer(user)
  end

  private

  def can_manage_stats_tickets
    can :create, Stats::Ticket do |stats|
      stats_not_started?(stats)
    end
  end

  def can_manage_ticket_reports
    can :create, TicketReport
  end

  def can_manage_gross_exports
    can :create, GrossExport
  end

  def can_show_protester_info
    can :show_protester_info, GrossExport
  end

  def can_manage_evaluation_exports
    can :create, EvaluationExport
  end

  # Helpers

  def resource_organ_eql?(resource, user)
    resource.organ_id == user.organ_id
  end

  def resource_subnet_eql?(resource, user)
    resource.subnet_id == user.subnet_id
  end

  def ticket_department_eql?(ticket_department, user)
    ticket_department.department_id == user.department_id
  end

  def ticket_created_by_user?(ticket, user)
    ticket.created_by == user
  end

  ## Stats::Ticket

  def stats_not_started?(stats)
    stats.status.present? && !stats.started?
  end


  ## Users

  def can_manage_itself(current_user)
    can [:show, :edit, :update], User do |user|
      current_user == user
    end
  end


  ## Tickets

  def can_create_and_search_tickets
    can [:create, :search], Ticket
  end

  def can_read_ticket(user)
    can :read, Ticket do |ticket|
      ticket.new_record? || user_can_manage_ticket?(ticket, user) || ticket_created_by_user?(ticket, user)
    end
  end

  def can_history_ticket(user)
    can :history, Ticket do |ticket|
      ticket_created_by_user?(ticket, user) || user_able_to_history_ticket(ticket, user)
    end
  end

  def user_able_to_history_ticket(ticket, user)
    if ticket.parent?
      ticket.tickets.any? { |child| user_can_manage_ticket?(child, user) }
    else
      user_can_manage_ticket?(ticket, user)
    end
  end

  def can_change_ticket_type(user)
    can :change_type, Ticket do |ticket|
      user_can_manage_ticket?(ticket, user) &&
      #
      # Não devemos poder alterar um SOU anônimo para um SIC, pois não existe SIC Anônimo
      #
      ! ticket.anonymous? &&

      # é obrigatório SIC possuir documento
      ! ticket.document.blank? &&

      # não deve existir ticket da rede ouvir do tipo SIC
      ! ticket.rede_ouvir?
    end
  end

  def can_change_sou_type(user)
    can :change_sou_type, Ticket do |ticket|
      can?(:edit, ticket) && !ticket_created_by_user?(ticket, user) && !ticket.denunciation?
    end
  end

  def can_clone_ticket(user)
    can :clone_ticket, Ticket do |ticket|
      user_can_manage_ticket?(ticket, user)
    end
  end

  def can_forward_ticket(user)
    can :forward, Ticket do |ticket|
      user_can_manage_ticket?(ticket, user) &&
      ticket_able_to_forward?(ticket) && !ticket.rede_ouvir?
    end
  end

  def ticket_able_to_forward?(ticket)
    ticket.open? && ticket.classified? && !ticket.cge_validation?
  end

  def can_manage_share_ticket(user)
    can_share_ticket(user)
  end

  def can_share_ticket(user)
    can :share, Ticket do |ticket|
      user_can_manage_ticket?(ticket, user) &&
      ticket_able_to_share?(ticket) &&
      !ticket.reopened_without_organ?
    end
  end

  def ticket_able_to_share?(ticket)
    ticket.open? &&
    !ticket.partial_answer? &&
    !ticket.rede_ouvir? &&
    Ticket.within_share_deadline?(ticket.confirmed_at)
  end

  def can_manage_share_internal_area_ticket(user)
    can :share_internal_area, Ticket do |ticket|
      user_can_manage_ticket?(ticket, user) && ticket.open? && !ticket.rede_ouvir? && 
      !ticket.appeal?
    end
  end

  def can_transfer_ticket(user)
    can :transfer_organ, Ticket do |ticket|
      user_can_manage_ticket?(ticket, user) &&
      ticket_able_to_transfer?(ticket) &&
      Ticket.within_share_deadline?(ticket.confirmed_at) &&
      ticket.no_answers?
    end
  end

  def ticket_able_to_transfer?(ticket)
    ticket.open? && ticket.ticket_departments.blank? && !ticket.rede_ouvir?
  end

  def can_classify_ticket(user)
    can :classify, Ticket do |ticket|
      (ticket.parent_no_active_children? || user_can_manage_ticket?(ticket, user)) &&
      !ticket.statuses_blocked_for_answer? && !ticket.rede_ouvir?
    end
  end

  def can_classify_without_organ_ticket
    can :classify_without_organ, Ticket do |ticket|
      ticket.child? || (ticket.no_children? && !ticket.appeal?)
    end
  end

  def can_view_ticket_user_info(user)
    can :view_user_info, Ticket do |ticket|
      (user_can_manage_ticket?(ticket, user) || ticket_created_by_user?(ticket, user)) &&
      !ticket.denunciation? && !ticket.hide_personal_info?
    end
  end

  def can_view_ticket_user_password(user)
    can :view_user_password, Ticket do |ticket|
      if ticket.sou?
        have_permission_to_view_user_password(ticket, user)
      else
        have_permission_to_view_user_password(ticket, user) &&
        ticket_created_10_minutes(ticket)
      end
    end
  end

  def have_permission_to_view_user_password(ticket, user)
    user_can_manage_ticket?(ticket, user) ||
    ticket_created_by_user?(ticket, user) ||
    user.denunciation_tracking?
  end

  def ticket_created_10_minutes(ticket)
    ((Time.current - ticket.created_at).to_i / 60) < 10
  end

  def can_manage_note(user)
    can [:edit_note, :update_note], Ticket
  end

  def can_email_reply(user)
    can :email_reply, Ticket do |ticket|
      user_can_manage_ticket?(ticket, user) &&
      ticket_able_to_email_reply?(ticket)
    end
  end

  def ticket_able_to_email_reply?(ticket)
    if ticket.parent?
      Answer.final.exists?(ticket: [ticket] + ticket.tickets, status: [:cge_approved, :call_center_approved, :user_evaluated])
    else
      ticket.final_answer?
    end
  end

  def can_delete_share_ticket(_)
    can :delete_share, Ticket do |ticket|
      ticket.child? &&
      ticket.sectoral_attendance? &&
      !ticket.reopened?
    end
  end


  ## Attachments

  def can_destroy_attachment(user)
    can :destroy, Attachment do |attachment|
      attachment_owner_id(attachment) == user.id
    end
  end


  ## AnswerTemplates

  def can_manage_answer_templates(user)
    can :manage, AnswerTemplate do |answer_template|
      answer_template.user_id == user.id
    end
  end

  def can_view_answer_type(user)
    can :view_answer_type, Ticket do |ticket|
      user.sectoral?
    end
  end

  def can_view_answer_type_label(user)
    can :view_answer_type_label, Ticket do |ticket|
      
      !(user.internal? || 
        (
          user.sou_sectoral? &&
          ticket.denunciation?) ||
          (user.security_organ?)
        )
      
    end
  end

end
