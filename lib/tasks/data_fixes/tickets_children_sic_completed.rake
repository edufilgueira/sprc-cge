namespace :data_fixes do

  # para testar em produção:
  # Answer.call_center_approved.left_joins(:ticket).where('tickets.parent_id is null AND tickets.childs_count > 0').count
  # Answer.call_center_approved.left_joins(:ticket).where.not('tickets.parent_id is null').count
  task tickets_children_sic_completed: :environment do

    # Todas as respostas 'sic - finalizado' fornecido pelo atendente 155
    Answer.call_center_approved.each do |answer|
      ticket = answer.ticket

      children = ticket.tickets

      # assumindo que todos os atendimentos sic-finalizado possuem apenas um filho pela query no banco
      if ticket.parent? && children.size == 1
        children.each do |child|

          ticket_log = answer.ticket_log
          user_id = ticket_log.data[:responsible_user_id]
          user = User.find(user_id)

          # movendo todas as resposta para os tickets filhos
          answer.update(ticket: child)

          ticket_log_data =
            {
              responsible_user_id: user_id,
              responsible_organ_id: child.organ_id,
              responsible_subnet_id: child.subnet_id
            }

          # gerando novos logs para a resposta dos tickets filhos
          RegisterTicketLog.call(child, user, :answer, { resource: answer, data: ticket_log_data } )
        end
      end
    end
  end
end
