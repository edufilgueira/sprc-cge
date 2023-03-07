namespace :data_fixes do

  # Corrige todos os tickets que foram abertos pelo Atendimento do 155 como
  # :sic_completed, onde ao criar com resposta o controller não adicionava o
  # :responded_at no ticket, causando impactos nos dados do SIC report
  task fix_tickets_attendance_responded_at: :environment do

    tickets_parent = Ticket.parent_tickets.joins(:attendance)
      .where(attendances: { service_type: :sic_completed }, status: :replied, responded_at: nil)

    tickets_parent.each do |ticket|
      # como é um attendance :sic_completed, a resposta é adicionada na hora da criação
      ticket.responded_at = ticket.confirmed_at

      ticket.tickets.each{ |child| child.responded_at = ticket.responded_at }

      ticket.save
    end
  end
end
