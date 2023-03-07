class PlatformController < ApplicationController
  include ::AuthorizedController

  before_action :require_user

  helper_method [
    :namespace
  ]

  # Helper methods

  def namespace
    :platform
  end

  def filtered_tickets_with_answer_pending_research(scope)
    scope = current_user.tickets.final_answer.from_type(ticket_type)

    scope.each do |ticket_parent|
      all_children_surveys = []

      if ticket_parent.tickets.any?
        ticket_parent.tickets.each do |ticket|
          all_children_surveys << all_answers_with_surveys?(ticket.answers.final)
        end
      end

      if all_answers_with_surveys?(ticket_parent.answers) && (all_children_surveys.exclude? false)
        scope = scope.where.not(id: ticket_parent.id)
      end

      # Existe ticket filho sem other_organs ou DPGE selecionado? 
      if Ticket.where(parent_id: ticket_parent.id).with_ticket_finished.present? 
        scope = scope.where.not(id: ticket_parent.id)
      end
    end

    scope
  end


  private

  def require_user
    redirect_to new_user_session_path unless current_user.user?
  end

  def all_answers_with_surveys?(answers)
    all_surveys = true
    
    # caso o ticket esteja finalizado e sem resposta, o mesmo será
    # considerado como desabilitado para pesquisa de satisfação do cidadão.
    answers.each do |answer|
      return false if answer.evaluation.nil?
    end

    all_surveys
  end
end
