module StatesHelper

  def states_for_select
    State.sorted.pluck(:acronym, :id)
  end

  def states_default_selected_for_ticket(ticket, user)
    ticket.city&.state_id || states_default_selected_for_user(user)
  end

  def states_default_selected_for_user(user)
    user&.city&.state_id || State.default&.id
  end

end
