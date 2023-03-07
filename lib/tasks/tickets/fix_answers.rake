namespace :tickets do
  namespace :fix_answers do
    desc "Corrigindo inconsistencias percebidas na aba de resolubilidade"

    task update: :environment  do |t|
      # Alterar a resposta para 'cge_rejected' nas manifestações de 2020 caso a mesma possua resposta e em seguida uma transferencia na mesma versão.
      # Tickets que foram respondidos e depois foram transferidos devem estar com a resposta rejeitada
      # ticket_ids 1642552, 1804345
      Answer.where(id: [790329, 892251]).update_all(status: :cge_rejected)

      # Ticket estava com version 0 porem foi criado apos uma reabertura portanto deveria estar com version 1
      # ticket_id 1777715
      Answer.find(867677).update(version: 1)

      # Ticket possuia 2 classificacoes ativas
      # ticket_id 1787565
      Classification.find(749394).update_column(:deleted_at, DateTime.now)

      # ticket_id 1762335
      Answer.find(874325).update(deadline: -4, sectoral_deadline: -4)

      # ticket_id 1764710
      Answer.find(872304).update(deadline: -14, sectoral_deadline: -14)

      # ticket_id 1737250
      # Apos uma reposta parcial houve uma prorrogacao de prazo nao atualizando o prazo da resposta parcial
      Answer.find(850661).update(deadline: 13, sectoral_deadline: 13)

      # ticket_id 1727632
      # sectoral_deadline nao deve ser atualizado apos edicao ou confirmacao da resposta somente a deadline
      Answer.find(861817).update(sectoral_deadline: 0)

      # ticket_id 1668935
      # Apos uma reposta parcial houve uma prorrogacao de prazo nao atualizando o prazo da resposta parcial
      Answer.find(804454).update(sectoral_deadline: 7)

      # Resposta invalidada deve ser contabilizada na aba de resolubilidade por isso foi criada essa resposta igual a sua justificativa de invalidacao
      # Ticket id 1634572
      ticket_log = TicketLog.find(7483653)
      Answer.create(
        answer_type: :final,
        answer_scope: :sectoral,
        status: :cge_approved,
        classification: :sou_could_not_verify,
        ticket_id: ticket_log.ticket_id,
        created_at: ticket_log.created_at,
        updated_at: ticket_log.updated_at,
        version: 10,
        description: ticket_log.description,
        original_description: ticket_log.description,
        user_id: ticket_log.responsible_id,
        deadline: ticket_log.ticket.deadline,
        sectoral_deadline: ticket_log.ticket.deadline
      )

      # Ticket id 1660210
      ticket_log = TicketLog.find(7564535)
      Answer.create(
        answer_type: :final,
        answer_scope: :sectoral,
        status: :cge_approved,
        classification: :sou_could_not_verify,
        ticket_id: ticket_log.ticket_id,
        created_at: ticket_log.created_at,
        updated_at: ticket_log.updated_at,
        version: 1,
        description: ticket_log.description,
        original_description: ticket_log.description,
        user_id: ticket_log.responsible_id,
        deadline: ticket_log.ticket.deadline,
        sectoral_deadline: ticket_log.ticket.deadline
      )

      # Ticket id 1660224
      ticket_log = TicketLog.find(7564943)
      Answer.create(
        answer_type: :final,
        answer_scope: :sectoral,
        status: :cge_approved,
        classification: :sou_could_not_verify,
        ticket_id: ticket_log.ticket_id,
        created_at: ticket_log.created_at,
        updated_at: ticket_log.updated_at,
        version: 1,
        description: ticket_log.description,
        original_description: ticket_log.description,
        user_id: ticket_log.responsible_id,
        deadline: ticket_log.ticket.deadline,
        sectoral_deadline: ticket_log.ticket.deadline
      )

      # Ticket id 1660229
      ticket_log = TicketLog.find(7570269)
      Answer.create(
        answer_type: :final,
        answer_scope: :sectoral,
        status: :cge_approved,
        classification: :sou_could_not_verify,
        ticket_id: ticket_log.ticket_id,
        created_at: ticket_log.created_at,
        updated_at: ticket_log.updated_at,
        version: 1,
        description: ticket_log.description,
        original_description: ticket_log.description,
        user_id: ticket_log.responsible_id,
        deadline: ticket_log.ticket.deadline,
        sectoral_deadline: ticket_log.ticket.deadline
      )

      # Ticket id 1660232
      ticket_log = TicketLog.find(7564947)
      Answer.create(
        answer_type: :final,
        answer_scope: :sectoral,
        status: :cge_approved,
        classification: :sou_could_not_verify,
        ticket_id: ticket_log.ticket_id,
        created_at: ticket_log.created_at,
        updated_at: ticket_log.updated_at,
        version: 1,
        description: ticket_log.description,
        original_description: ticket_log.description,
        user_id: ticket_log.responsible_id,
        deadline: ticket_log.ticket.deadline,
        sectoral_deadline: ticket_log.ticket.deadline
      )

      # Ticket id 1660234
      ticket_log = TicketLog.find(7564954)
      Answer.create(
        answer_type: :final,
        answer_scope: :sectoral,
        status: :cge_approved,
        classification: :sou_could_not_verify,
        ticket_id: ticket_log.ticket_id,
        created_at: ticket_log.created_at,
        updated_at: ticket_log.updated_at,
        version: 1,
        description: ticket_log.description,
        original_description: ticket_log.description,
        user_id: ticket_log.responsible_id,
        deadline: ticket_log.ticket.deadline,
        sectoral_deadline: ticket_log.ticket.deadline
      )

      # Ticket id 1660243
      ticket_log = TicketLog.find(7564959)
      Answer.create(
        answer_type: :final,
        answer_scope: :sectoral,
        status: :cge_approved,
        classification: :sou_could_not_verify,
        ticket_id: ticket_log.ticket_id,
        created_at: ticket_log.created_at,
        updated_at: ticket_log.updated_at,
        version: 1,
        description: ticket_log.description,
        original_description: ticket_log.description,
        user_id: ticket_log.responsible_id,
        deadline: ticket_log.ticket.deadline,
        sectoral_deadline: ticket_log.ticket.deadline
      )

      # Ticket id 1660256
      ticket_log = TicketLog.find(7564543)
      Answer.create(
        answer_type: :final,
        answer_scope: :sectoral,
        status: :cge_approved,
        classification: :sou_could_not_verify,
        ticket_id: ticket_log.ticket_id,
        created_at: ticket_log.created_at,
        updated_at: ticket_log.updated_at,
        version: 1,
        description: ticket_log.description,
        original_description: ticket_log.description,
        user_id: ticket_log.responsible_id,
        deadline: ticket_log.ticket.deadline,
        sectoral_deadline: ticket_log.ticket.deadline
      )

      # Ticket id 1660260
      ticket_log = TicketLog.find(7564965)
      Answer.create(
        answer_type: :final,
        answer_scope: :sectoral,
        status: :cge_approved,
        classification: :sou_could_not_verify,
        ticket_id: ticket_log.ticket_id,
        created_at: ticket_log.created_at,
        updated_at: ticket_log.updated_at,
        version: 1,
        description: ticket_log.description,
        original_description: ticket_log.description,
        user_id: ticket_log.responsible_id,
        deadline: ticket_log.ticket.deadline,
        sectoral_deadline: ticket_log.ticket.deadline
      )

      # Ticket id 1669378
      ticket_log = TicketLog.find(7587614)
      Answer.create(
        answer_type: :final,
        answer_scope: :sectoral,
        status: :cge_approved,
        classification: :sou_could_not_verify,
        ticket_id: ticket_log.ticket_id,
        created_at: ticket_log.created_at,
        updated_at: ticket_log.updated_at,
        version: 1,
        description: ticket_log.description,
        original_description: ticket_log.description,
        user_id: ticket_log.responsible_id,
        deadline: ticket_log.ticket.deadline,
        sectoral_deadline: ticket_log.ticket.deadline
      )

      # Ticket id 1669380
      ticket_log = TicketLog.find(7587612)
      Answer.create(
        answer_type: :final,
        answer_scope: :sectoral,
        status: :cge_approved,
        classification: :sou_could_not_verify,
        ticket_id: ticket_log.ticket_id,
        created_at: ticket_log.created_at,
        updated_at: ticket_log.updated_at,
        version: 1,
        description: ticket_log.description,
        original_description: ticket_log.description,
        user_id: ticket_log.responsible_id,
        deadline: ticket_log.ticket.deadline,
        sectoral_deadline: ticket_log.ticket.deadline
      )

      # Ticket id 1669382
      ticket_log = TicketLog.find(7591811)
      Answer.create(
        answer_type: :final,
        answer_scope: :sectoral,
        status: :cge_approved,
        classification: :sou_could_not_verify,
        ticket_id: ticket_log.ticket_id,
        created_at: ticket_log.created_at,
        updated_at: ticket_log.updated_at,
        version: 1,
        description: ticket_log.description,
        original_description: ticket_log.description,
        user_id: ticket_log.responsible_id,
        deadline: ticket_log.ticket.deadline,
        sectoral_deadline: ticket_log.ticket.deadline
      )

      # Ticket id 1669384
      ticket_log = TicketLog.find(7591816)
      Answer.create(
        answer_type: :final,
        answer_scope: :sectoral,
        status: :cge_approved,
        classification: :sou_could_not_verify,
        ticket_id: ticket_log.ticket_id,
        created_at: ticket_log.created_at,
        updated_at: ticket_log.updated_at,
        version: 1,
        description: ticket_log.description,
        original_description: ticket_log.description,
        user_id: ticket_log.responsible_id,
        deadline: ticket_log.ticket.deadline,
        sectoral_deadline: ticket_log.ticket.deadline
      )

      # Ticket id 1669390
      ticket_log = TicketLog.find(7591820)
      Answer.create(
        answer_type: :final,
        answer_scope: :sectoral,
        status: :cge_approved,
        classification: :sou_could_not_verify,
        ticket_id: ticket_log.ticket_id,
        created_at: ticket_log.created_at,
        updated_at: ticket_log.updated_at,
        version: 1,
        description: ticket_log.description,
        original_description: ticket_log.description,
        user_id: ticket_log.responsible_id,
        deadline: ticket_log.ticket.deadline,
        sectoral_deadline: ticket_log.ticket.deadline
      )

      # Ticket id 1669392
      ticket_log = TicketLog.find(7591831)
      Answer.create(
        answer_type: :final,
        answer_scope: :sectoral,
        status: :cge_approved,
        classification: :sou_could_not_verify,
        ticket_id: ticket_log.ticket_id,
        created_at: ticket_log.created_at,
        updated_at: ticket_log.updated_at,
        version: 1,
        description: ticket_log.description,
        original_description: ticket_log.description,
        user_id: ticket_log.responsible_id,
        deadline: ticket_log.ticket.deadline,
        sectoral_deadline: ticket_log.ticket.deadline
      )

      # Ticket id 1669394
      ticket_log = TicketLog.find(7591840)
      Answer.create(
        answer_type: :final,
        answer_scope: :sectoral,
        status: :cge_approved,
        classification: :sou_could_not_verify,
        ticket_id: ticket_log.ticket_id,
        created_at: ticket_log.created_at,
        updated_at: ticket_log.updated_at,
        version: 1,
        description: ticket_log.description,
        original_description: ticket_log.description,
        user_id: ticket_log.responsible_id,
        deadline: ticket_log.ticket.deadline,
        sectoral_deadline: ticket_log.ticket.deadline
      )

      # Ticket id 1669396
      ticket_log = TicketLog.find(7591849)
      Answer.create(
        answer_type: :final,
        answer_scope: :sectoral,
        status: :cge_approved,
        classification: :sou_could_not_verify,
        ticket_id: ticket_log.ticket_id,
        created_at: ticket_log.created_at,
        updated_at: ticket_log.updated_at,
        version: 1,
        description: ticket_log.description,
        original_description: ticket_log.description,
        user_id: ticket_log.responsible_id,
        deadline: ticket_log.ticket.deadline,
        sectoral_deadline: ticket_log.ticket.deadline
      )

      # Ticket id 1669398
      ticket_log = TicketLog.find(7591860)
      Answer.create(
        answer_type: :final,
        answer_scope: :sectoral,
        status: :cge_approved,
        classification: :sou_could_not_verify,
        ticket_id: ticket_log.ticket_id,
        created_at: ticket_log.created_at,
        updated_at: ticket_log.updated_at,
        version: 1,
        description: ticket_log.description,
        original_description: ticket_log.description,
        user_id: ticket_log.responsible_id,
        deadline: ticket_log.ticket.deadline,
        sectoral_deadline: ticket_log.ticket.deadline
      )

      # Ticket id 1669400
      ticket_log = TicketLog.find(7591871)
      Answer.create(
        answer_type: :final,
        answer_scope: :sectoral,
        status: :cge_approved,
        classification: :sou_could_not_verify,
        ticket_id: ticket_log.ticket_id,
        created_at: ticket_log.created_at,
        updated_at: ticket_log.updated_at,
        version: 1,
        description: ticket_log.description,
        original_description: ticket_log.description,
        user_id: ticket_log.responsible_id,
        deadline: ticket_log.ticket.deadline,
        sectoral_deadline: ticket_log.ticket.deadline
      )

      # Ticket id 1809333
      ticket_log = TicketLog.find(8420588)
      Answer.create(
        answer_type: :final,
        answer_scope: :sectoral,
        status: :cge_approved,
        classification: :sou_could_not_verify,
        ticket_id: ticket_log.ticket_id,
        created_at: ticket_log.created_at,
        updated_at: ticket_log.updated_at,
        version: 1,
        description: ticket_log.description,
        original_description: ticket_log.description,
        user_id: ticket_log.responsible_id,
        deadline: ticket_log.ticket.deadline,
        sectoral_deadline: ticket_log.ticket.deadline
      )

      # Ticket id 1817748
      ticket_log = TicketLog.find(8418064)
      Answer.create(
        answer_type: :final,
        answer_scope: :sectoral,
        status: :cge_approved,
        classification: :sou_could_not_verify,
        ticket_id: ticket_log.ticket_id,
        created_at: ticket_log.created_at,
        updated_at: ticket_log.updated_at,
        version: 1,
        description: ticket_log.description,
        original_description: ticket_log.description,
        user_id: ticket_log.responsible_id,
        deadline: ticket_log.ticket.deadline,
        sectoral_deadline: ticket_log.ticket.deadline
      )

      # Ticket id 1802302
      ticket_log = TicketLog.find(8415887)
      Answer.create(
        answer_type: :final,
        answer_scope: :sectoral,
        status: :cge_approved,
        classification: :sou_could_not_verify,
        ticket_id: ticket_log.ticket_id,
        created_at: ticket_log.created_at,
        updated_at: ticket_log.updated_at,
        version: 1,
        description: ticket_log.description,
        original_description: ticket_log.description,
        user_id: ticket_log.responsible_id,
        deadline: ticket_log.ticket.deadline,
        sectoral_deadline: ticket_log.ticket.deadline
      )

      # Ticket esta com deadline congelado sendo que nao teve resposta parcial aprovada
      ticket = Ticket.find(1761548)
      ticket.deadline = (ticket.deadline_ends_at - Date.today).to_i
      ticket.save
    end
  end
end