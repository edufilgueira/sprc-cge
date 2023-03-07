namespace :answers do
  namespace :fix do
    task create: :environment do
      # ticket_id da CC 1638921 / parent protocol 5322126
      # TicketLog nao precisa de um action reopen visto que ja tem cadastrada uma pseudo reabertura cadastrada em sua versao 1.
      # Provavelmente esse action de reabertura foi adicionado manualmente visto que o updated_at esta em 09 Mar 2020 15:25:06 e essa demanda foi finalizada em 17/01/2020 as 11:37
      TicketLog.find(7540649).destroy

      # ticket_id da CGD 1643832 / parent protocol 5348747
      # Ticket recebeu uma resposta parcial no prazo porem por motivo desconhecido a resposta final foi dada fora do prazo
      # Deadline da resposta final foi ajustada para ficar a mesma da resposta parcial
      answer = Answer.find(879601)
      answer.sectoral_deadline = 15
      answer.save
    end
  end
end
