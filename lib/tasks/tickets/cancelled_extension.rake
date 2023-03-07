namespace :tickets do
  namespace :cancelled_extension do
    desc "Cancelar prorrogação de todos os tickets, com status daṕrorrogação in_progress e internal_status finalizado sem reabertura"

    task update: :environment  do |t|
      list_tickets_ids = Extension.in_progress.pluck(:ticket_id)

      list_tickets_ids_with_internal_status  = Ticket.where(internal_status: 8, id: list_tickets_ids).ids

      puts "Iniciando atualização"
      Extension.where(ticket_id: list_tickets_ids_with_internal_status).update(status: :cancelled)

      puts "Lista de Ticket_ids atualizados: #{list_tickets_ids_with_internal_status}"
      puts "---------------------------------------------------------"
      puts "Atualização Concluída com sucesso!"
    end
  end
end