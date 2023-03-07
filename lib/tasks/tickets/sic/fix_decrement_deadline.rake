# Essa rake corrige o problema ocorrido devido a uma falha no formulário para geração de atendimentos e validações
# incorretas no modelo de Ticket.

namespace :tickets do
    namespace :sic do
      namespace :fix_deadline_2022 do
        desc "Alterando todos os prazos de manifestações de 2022"
  
        task update: :environment  do |t|
          # Busca lista de tickets com decrement_deadline incorreto, essa lista já inclui os tickets com orgãos duplicados  
          def tickets
            Ticket.where(
              internal_status: Ticket::INTERNAL_STATUSES_TO_LOCK_DEADLINE, 
              decrement_deadline: true
            )
          end

          $stdout = File.new("#{Rails.root}/log/fix_deadline_2022.out", 'w')
          $stdout.sync = true
  
          total = tickets.count
          tickets.find_each.with_index do |ticket, index|
            begin
              ApplicationRecord.transaction do
                deadline_was = ticket.deadline

                if ticket.deadline_ends_at.present? && ticket.responded_at.present?
                  ticket.deadline = (ticket.deadline_ends_at.to_date - ticket.responded_at.to_date).to_i
                end

                ticket.decrement_deadline = false
  
                ticket.save(validate: false)
  
                p "Ticket id: #{ticket.id} | Protocol: #{ticket.protocol} | Ticket deadline was #{deadline_was} | Ticket deadline now #{ticket.deadline}"
              end
            rescue
              p "#Error - Ticket id: #{ticket.id} | Protocol: #{ticket.protocol}"
            end
            p "#{index+1} / #{total}"
          end
        end
      end
    end
  end