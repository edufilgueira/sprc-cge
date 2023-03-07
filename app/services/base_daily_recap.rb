class BaseDailyRecap

  private

  def recap
    {
      sou: summary(:sou),
      sic: summary(:sic)
    }
  end

  def summary(ticket_type)
    Ticket::FILTER_DEADLINE.keys.map do |deadline|
      [deadline, ticket_count(ticket_type, deadline)]
    end.to_h
  end

  def ticket_count(ticket_type, deadline)
    ticket_from_type(ticket_type, deadline).distinct.count
  end

  def ticket_from_type(ticket_type, deadline)
    ticket_deadline(deadline).from_type(ticket_type)
  end

  def ticket_deadline(deadline)
    ticket_active.with_deadline(deadline)
  end

  def ticket_active
    tickets.active
  end

  def tickets
    # O escopo deve ser sobrescrito para cada classe
  end

end
