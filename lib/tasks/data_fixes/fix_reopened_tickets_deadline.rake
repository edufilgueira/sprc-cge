namespace :data_fixes do

  # Corrige o prazo das manifestações que foram reabertas e não tiveram o prazo recalculados
  task fix_reopened_tickets_deadline: :environment do

    # obtem tickets reabertos que estejam ativos
    tickets = Ticket.sou.where.not(reopened_at: nil, internal_status: Ticket::INACTIVE_STATUSES)

    tickets.find_each do |ticket|

      # Lógica copiada de Ticket#set_deadline, ajustado apenas para
      # considerar a contagem a partir de reopened_at ao invés da data atual
      weekday = Holiday.next_weekday(Ticket.response_deadline(:sou), ticket.reopened_at)
      ticket.deadline_ends_at = ticket.reopened_at + weekday.days
      ticket.deadline = (ticket.deadline_ends_at - Date.today).to_i
      ticket.save!
    end
  end
end
