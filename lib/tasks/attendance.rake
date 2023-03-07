namespace :attendances do
  task fix_denunciation_description: :environment do
    desc "Corrige manifestações de denuncia criadas pelo atendimento 155"

    Attendance.joins(:ticket).where(tickets: {sou_type: :denunciation}).each do |attendance|
      ticket = attendance.ticket
      ticket.update_attribute(:denunciation_description, attendance.description)

      ticket.tickets.each do |child|
        child.update_attribute(:denunciation_description, attendance.description)
      end
    end
  end
end
