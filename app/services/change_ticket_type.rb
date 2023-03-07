class ChangeTicketType

  attr_accessor :ticket, :ticket_attributes

  def self.call(ticket, ticket_attributes={})
    new.call(ticket, ticket_attributes)
  end

  def call(ticket, ticket_attributes={})
    @ticket = ticket.parent || ticket
    @ticket_attributes = ticket_attributes

    change_tickets_type
  end

  private

  def change_tickets_type
    # muda o tipo do principal
    result = change_ticket_type(ticket)

    # muda o tipo dos filhos
    ticket.tickets.each do |ticket|
      result &&= change_ticket_type(ticket)
    end

    result
  end

  def change_ticket_type(ticket)
    if ticket.sou?
      update_sic_document(ticket)
      update_sic_anonymous(ticket)
      ticket.description = ticket.denunciation_description if ticket.denunciation?
      ticket.ticket_type = :sic
      ticket.sou_type = nil
    else
      ticket.public_ticket = false
      ticket.ticket_type = :sou
      ticket.assign_attributes(ticket_attributes) if ticket_attributes.present?
    end

    reference_date = ticket_date(ticket)
    deadline = ticket_deadline(ticket)
    weekday = Holiday.next_weekday(deadline, reference_date)

    ticket.deadline_ends_at = reference_date.to_date + weekday

    ticket.deadline = calculate_deadline(ticket.deadline_ends_at)

    ticket.save
  end

  def calculate_deadline(deadline_ends_at)
    (deadline_ends_at - Date.today).to_i
  end

  def update_sic_document(ticket)
    #
    # Regra de negócio: É obrigatório informar o documento para SIC
    #
    if ticket.document.blank?
      ticket.document_type = :other

      # XXX verificar uma forma melhor que '0'
      # talvez uma msg do tipo 'sem doc pois houve mudança de tipo'
      ticket.document = '0'
    end
  end

  def update_sic_anonymous(ticket)
    #
    # Regra de negócio: Não existe SIC anônimo e identificado sem nome
    #
    if ticket.anonymous?
      ticket.person_type = :individual
      ticket.anonymous = false

      # XXX verificar uma forma melhor que '0'
      # talvez uma msg do tipo 'sem nome pois houve mudança de tipo'
      ticket.name = '0' if ticket.name.blank?
    end
  end

  def ticket_date(ticket)
    ticket.reopened_at || ticket.confirmed_at
  end

  def ticket_deadline(ticket)
    if ticket.extended?
      Ticket.response_extension(ticket.ticket_type)
    else
      Ticket.response_deadline(ticket.ticket_type)
    end
  end
end
