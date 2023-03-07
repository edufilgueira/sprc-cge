class Platform::HomeController < PlatformController

  helper_method [:status_count, :pending_research_count]

  # helpers

  def status_count(ticket_type)
    {
      active: actives(ticket_type),
      inactive: inactives(ticket_type)
    }
  end

  def pending_research_count(ticket_type)
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

    scope.count
  end

  private

  def actives(ticket_type)
    from_ticket_type(ticket_type).active.count
  end

  def inactives(ticket_type)
    from_ticket_type(ticket_type).inactive.count
  end

  def from_ticket_type(ticket_type)
    current_user.tickets.parent_tickets.from_type(ticket_type)
  end
end