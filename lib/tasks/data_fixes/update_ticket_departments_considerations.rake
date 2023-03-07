namespace :data_fixes do
  #
  # Concatena o texto de TicketDepartment#note com TicketLog#descriptions de forward para unidades
  #
  # TODO após rodar essa rotina e for aprovado, criar uma rake para dropar a coluna TicketDepartmen#note
  # TODO se aprovado limpar a descrição dos logs específicos
  #
  # TESTE para conferir dados
  # ticket_department = TicketDepartment.last
  # ticket = ticket_department.ticket
  # department = ticket_department.department
  # log = TicketLog.forward.where(resource: department, ticket: ticket).last
  # log_parent = TicketLog.forward.where(resource: department, ticket: ticket.parent).last if ticket.child?
  # justification = log.description
  # ticket_department.considerations
  # log.data[:considerations]
  # log_parent.data[:considerations]
  #
  task update_ticket_departments_considerations: :environment do

    TicketDepartment.all.each do |ticket_department|
      department = ticket_department.department
      ticket = ticket_department.ticket

      # Existe apenas um lo para encaminhamento de um ticket para um departamento
      log = TicketLog.forward.where(resource: department, ticket: ticket).last
      log_parent = TicketLog.forward.where(resource: department, ticket: ticket.parent).last if ticket.child?

      justification = log.is_a?(TicketLog) ? log.description : ''

      old_note = ticket_department.note
      new_note = old_note.present? ? "<p>Motivo:</p><p>#{old_note}</p>" : ''
      new_justification = justification.present? ? "<p>Observação:</p><p>#{justification}</p>" : ''

      # Geralmente o ouvidor copia e cola o texto do motivo para a observação
      consideration_text = justification == old_note ? old_note : "#{new_note}\n\n#{new_justification}"

      ticket_department.update_column(:considerations, consideration_text)
      log.update(data: log.data.merge({considerations: consideration_text})) if log&.data.present? && log.data[:considerations].blank?
      log_parent.update(data: log.data.merge({considerations: consideration_text})) if log_parent.present? && log_parent&.data[:considerations].blank?
    end
  end
end
