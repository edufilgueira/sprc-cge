namespace :tickets do
  namespace :maintenance do
    INITIAL_DEADLINE = 15
    ENTRY_DATE = Date.new(2019,03,29)
    CURRENT_DEADLINE = INITIAL_DEADLINE - (Date.today - ENTRY_DATE).to_i

    desc "Correção de Bug Gerado pela criação de nova subnet/subrede: caso SEDUC"
    task update_seduc_tickets_with_bug_subnet: :environment  do |t|
      def tickets_with_subnet_inconsistency
        organ = Organ.find_by_acronym('SEDUC')
        Ticket.where(organ: organ, unknown_subnet: false).where('subnet_id is null')
      end

      ActiveRecord::Base.transaction do

        tickets_inconsistent = tickets_with_subnet_inconsistency

        puts "Registros encontrados: #{tickets_inconsistent.count}"
        puts "Lista de ids que serão afetados: #{tickets_inconsistent.pluck(:id).sort}"

        tickets_inconsistent.update_all(unknown_subnet: true)
        tickets_not_affecteds = tickets_with_subnet_inconsistency
        puts "Registros não afetados: #{tickets_not_affecteds.count}"

      end
    end

  	desc "Corrigindo Protocolos sem resposta"
  	task :protocols_not_answered  => :environment  do |t|

      # sem resposta e com orgao: 16
      protocols_not_answered_and_with_organ = [
        4000022, 4000028, 4000029, 4000030, 4000066, 4000068, 4000069, 4000071,
        4000072, 4000073, 4000074, 4000106, 4000110, 4000111, 4000113, 4000114
      ]

      ActiveRecord::Base.transaction do
        protocols_not_answered_and_with_organ.each do |prot|
          Ticket.where(parent_protocol: prot).update(
            deadline: CURRENT_DEADLINE,
            deadline_ends_at: ENTRY_DATE + Holiday.next_weekday(INITIAL_DEADLINE, ENTRY_DATE),
            status: Ticket.statuses[:confirmed]
          )

          # recuperando o pai:
          parent_ticket = Ticket.where(parent_protocol: prot).first

          unknown_subnet = true
          subnet_id = nil

          # condição criada para corrigir as situações que os tickets filhos sabem
          # quem sao as subtnes.
          if prot == 4000074
            unknown_subnet = false
            subnet_id = 44
          elsif prot == 4000106
            unknown_subnet = false
            subnet_id = 42
          end

          # criando o filho:
          new_ticket = Ticket.new(
            description: parent_ticket.description,
            answer_type: parent_ticket.answer_type,
            email: parent_ticket.email,
            name: parent_ticket.name,
            protocol: Ticket.last.protocol.succ,
            created_by_id: nil,
            updated_by_id: parent_ticket.updated_by_id,
            deleted_at: parent_ticket.deleted_at,
            created_at: parent_ticket.created_at,
            updated_at: parent_ticket.updated_at,
            organ_id: parent_ticket.organ_id,
            encrypted_password: '',
            status: parent_ticket.status,
            sign_in_count: parent_ticket.sign_in_count,
            current_sign_in_at: parent_ticket.current_sign_in_at,
            last_sign_in_at: parent_ticket.last_sign_in_at,
            current_sign_in_ip: parent_ticket.current_sign_in_ip,
            last_sign_in_ip: parent_ticket.last_sign_in_ip,
            ticket_type: parent_ticket.ticket_type,
            sou_type: parent_ticket.sou_type,
            anonymous: parent_ticket.anonymous,
            unknown_organ: false,
            answer_phone: parent_ticket.answer_phone,
            answer_address_city_name: parent_ticket.answer_address_city_name,
            answer_address_street: parent_ticket.answer_address_street,
            answer_address_number: parent_ticket.answer_address_number,
            answer_address_zipcode: parent_ticket.answer_address_zipcode,
            answer_address_complement: parent_ticket.answer_address_complement,
            answer_address_neighborhood: parent_ticket.answer_address_neighborhood,
            internal_status: parent_ticket.internal_status,
            classified: parent_ticket.classified,
            parent_id: parent_ticket.id,
            reopened: parent_ticket.reopened,
            confirmed_at: parent_ticket.confirmed_at,
            deadline: parent_ticket.deadline,
            document_type: parent_ticket.document_type,
            document: parent_ticket.document,
            person_type: parent_ticket.person_type,
            deadline_ends_at: parent_ticket.deadline_ends_at,
            denunciation_organ_id: parent_ticket.denunciation_organ_id,
            denunciation_description: parent_ticket.denunciation_description,
            denunciation_date: parent_ticket.denunciation_date,
            denunciation_place: parent_ticket.denunciation_place,
            denunciation_assurance: parent_ticket.denunciation_assurance,
            denunciation_witness: parent_ticket.denunciation_witness,
            denunciation_evidence: parent_ticket.denunciation_evidence,
            reopened_at: parent_ticket.reopened_at,
            responded_at: parent_ticket.responded_at,
            used_input: parent_ticket.used_input,
            answer_classification: parent_ticket.answer_classification,
            call_center_responsible_id: parent_ticket.call_center_responsible_id,
            answer_cell_phone: parent_ticket.answer_cell_phone,
            priority: parent_ticket.priority,
            answer_twitter: parent_ticket.answer_twitter,
            answer_facebook: parent_ticket.answer_facebook,
            plain_password: nil,
            city_id: parent_ticket.city_id,
            social_name: parent_ticket.social_name,
            gender: parent_ticket.gender,
            call_center_allocation_at: parent_ticket.call_center_allocation_at,
            extended: parent_ticket.extended,
            unknown_subnet: unknown_subnet,
            subnet_id: subnet_id,
            used_input_url: parent_ticket.used_input_url,
            public_ticket: parent_ticket.public_ticket,
            published: parent_ticket.published,
            parent_protocol: parent_ticket.parent_protocol,
            appeals: parent_ticket.appeals,
            appeals_at: parent_ticket.appeals_at,
            answer_instagram: parent_ticket.answer_instagram,
            call_center_feedback_at: parent_ticket.call_center_feedback_at,
            denunciation_against_operator: parent_ticket.denunciation_against_operator,
            call_center_status: parent_ticket.call_center_status,
            parent_unknown_organ: parent_ticket.parent_unknown_organ,
            immediate_answer: parent_ticket.immediate_answer,
            target_address_zipcode: parent_ticket.target_address_zipcode,
            target_city_id: parent_ticket.target_city_id,
            target_address_street: parent_ticket.target_address_street,
            target_address_number: parent_ticket.target_address_number,
            target_address_neighborhood: parent_ticket.target_address_neighborhood,
            target_address_complement: parent_ticket.target_address_complement,
            unknown_classification: parent_ticket.unknown_classification,
            note: parent_ticket.note,
            isn_manifestacao: parent_ticket.isn_manifestacao,
            isn_manifestacao_entidade: parent_ticket.isn_manifestacao_entidade,
            rede_ouvir: parent_ticket.rede_ouvir
          )

          if new_ticket.save

            # atualização efetuada depois da criação do ticket filho, devido os
            # parâmetros do ticket pai serem utilizado no ticket filho.
            parent_ticket.update(
              organ_id: nil,
              unknown_organ: true,
              parent_id: nil,
              unknown_subnet: true
            )
            puts "### Filho criado para o protocolo: #{prot}"
            puts "### Sem Resposta e COM Orgão: #{prot}"
          else
            raise "### ERROR: #{new_ticket.errors.messages} - Protocolo Filho: #{new_ticket.protocol}, Protocolo PAI: #{prot}"
          end

        end #/ protocols_not_answered_and_with_organ.each
      end #/ transaction

      #sem resposta e sem orgao: 09
      protocols_not_answered_and_without_organ = [
        4000027, 4000031, 4000112, 4000119, 4000121, 4000122, 4000123, 4000125, 4000130
      ]

      ActiveRecord::Base.transaction do
        protocols_not_answered_and_without_organ.each do |prot|
          Ticket.where(parent_protocol: prot).update(
            deadline: CURRENT_DEADLINE,
            deadline_ends_at: ENTRY_DATE + Holiday.next_weekday(INITIAL_DEADLINE, ENTRY_DATE),
            status: Ticket.statuses[:confirmed]
          )
          puts "### Sem Resposta e SEM Orgão: #{prot}"
        end
      end

    end #/ task :protocols_not_answered


    desc "Corrigindo Protocolos com resposta Finalizado via aplicação"
    task :protocols_answered_with_finish_app  => :environment  do |t|
      # com resposta e sem orgao: 5
      protocols_answered_and_without_organ = [
        4000023, 4000108, 4000124, 4000126, 4000129
      ]

      ActiveRecord::Base.transaction do
        protocols_answered_and_without_organ.each do |prot|
          Ticket.where(protocol: prot).update(
            deadline: CURRENT_DEADLINE,
            deadline_ends_at: ENTRY_DATE + Holiday.next_weekday(INITIAL_DEADLINE, ENTRY_DATE),
            status: Ticket.statuses[:replied],
            internal_status: Ticket.internal_statuses[:final_answer],
            responded_at: DateTime.now
          )
          puts "### Protocolo Status Respondido e Finalizado via Aplicação: #{prot}"
        end#/ protocols_answered_and_without_organ.each
      end#/ transaction
    end# task :protocols_answered_with_finish_app


    desc "Corrigindo Protocolo com resposta da ARCE e DETRAN"
    task :protocols_answered_arce_and_detran  => :environment  do |t|
      # ARCE e DETRAN: 2
      protocols_answered_and_with_organ = [4000012, 4000067]

      ActiveRecord::Base.transaction do
        protocols_answered_and_with_organ.each do |prot|
          Ticket.where(protocol: prot).update(
            deadline: CURRENT_DEADLINE,
            deadline_ends_at: ENTRY_DATE + Holiday.next_weekday(INITIAL_DEADLINE, ENTRY_DATE),
            status: Ticket.statuses[:confirmed],
            internal_status: Ticket.internal_statuses[:sectoral_attendance]
          )
          puts "### Protocolo Status Respondido e Finalizado via Aplicação: #{prot}"

          # Recuperando o PAI
          ticket_father = Ticket.find_by_protocol(prot)

          # criando o filho:
          ticket_son = ticket_father.dup
          ticket_son.organ_id = ticket_father.organ_id
          ticket_son.encrypted_password = ''
          ticket_son.created_by_id = nil
          ticket_son.unknown_organ = false
          ticket_son.parent_id = ticket_father.id
          ticket_son.plain_password = nil
          ticket_son.unknown_subnet = true
          ticket_son.protocol = Ticket.last.protocol.succ

          if ticket_son.save
            # atualização efetuada depois da criação do ticket filho, devido os
            # parâmetros do ticket pai serem utilizado no ticket filho.

            puts "### Filho criado para o protocolo da ARCE e DETRAN: Filho - #{ticket_son.protocol}"

            ticket_father.update(
              organ_id: nil,
              unknown_organ: true,
              parent_id: nil,
              unknown_subnet: true
            )

            puts "### Atualizado o Ticket Pai: #{prot}"

          else
            raise "### ERROR: #{ticket_son.errors.messages} - Protocolo Filho da ARCE e DETRAN: #{ticket_son.protocol}, Protocolo PAI: #{prot}"
          end

        end#/ protocols_answered_and_without_organ.each
      end#/ transaction
    end# task :protocols_answered_with_finish_app


    desc "Corrigir Encaminhamento para a área interna PEFOCE"
    task :encaminhamento_area_interna_pefoce  => :environment  do |t|
      # PEFOCE: 1
      Ticket.where(protocol: 4000028).update(
        status: Ticket.statuses[:confirmed],
        classified: true
      )
      puts "### Protocolo Atualizado PEFOCE: 4000028"
    end

    desc "Corrigir Encaminhamento para a DPGE e orgão PMCE"
    task :forward_cge_for_dpge_and_pmce => :environment do |t|
      parent_protocols = [4000072, 4000022]

      parent_protocols.each do |parent_prot|
        ticket_son_old = Ticket.where("parent_protocol = '#{parent_prot}' and parent_id IS NOT NULL")
        if !ticket_son_old.empty?
          ticket_son_old = ticket_son_old.first
          ticket_son_new = ticket_son_old.dup

          # Alterando os valores de protocol para o ticket novo
          ActiveRecord::Base.transaction do
            ticket_son_new.protocol = Ticket.order(:id).last.protocol.succ # alteração necessaria para corrigir duplicidade de protocolos
            ticket_son_new.classified = true

            # deve ser deletado primeiro devido a unicidade do orgão no model
            ticket_son_old.destroy
            puts "Protocolo Filho Antigo Deletado: #{ticket_son_old.protocol}"

            if ticket_son_new.save
              puts "Protocolo Filho Novo Criado: #{ticket_son_new.protocol}"
              # atualizar as tabelas necessárias
              TicketLog.where(ticket_id: ticket_son_old.id).update(ticket_id: ticket_son_new.id)
              puts "Atualizado o campo ticket_id do TicketLog: #{ticket_son_old.protocol} - #{ticket_son_old.id} para #{ticket_son_new.protocol} - #{ticket_son_new.id}"

            end
          end
        else
          puts "O protocolo Pai #{parent_prot} Não tem Filho"
        end
      end
    end


    desc "Corrigir Todos os filhos duplicados"
    task :fix_duplicate_child_protocols => :environment do |t|
      parent_protocols = [
        4000028, 4000029, 4000030, 4000066, 4000068, 4000069, 4000071,
        4000073, 4000074, 4000106, 4000110, 4000111, 4000113, 4000114,
        4000012, 4000067
      ]

      parent_protocols.each do |parent_prot|
        ticket_son_old = Ticket.where("parent_protocol = '#{parent_prot}' and parent_id IS NOT NULL")
        if !ticket_son_old.empty?
          ticket_son_old = ticket_son_old.first
          ticket_son_new = ticket_son_old.dup

          # Alterando os valores de protocol para o ticket novo
          ActiveRecord::Base.transaction do
            ticket_son_new.protocol = Ticket.order(:id).last.protocol.succ # alteração necessaria para corrigir duplicidade de protocolos

            # deve ser deletado primeiro devido a unicidade do orgão no model
            ticket_son_old.destroy
            puts "Protocolo Filho Antigo Deletado: #{ticket_son_old.protocol}"

            if ticket_son_new.save
              puts "Protocolo Filho Novo Criado: #{ticket_son_new.protocol}"
              # atualizar as tabelas necessárias
              TicketLog.where(ticket_id: ticket_son_old.id).update(ticket_id: ticket_son_new.id)
              puts "Atualizado o campo ticket_id do TicketLog: #{ticket_son_old.protocol} - #{ticket_son_old.id} para #{ticket_son_new.protocol} - #{ticket_son_new.id}"

            end
          end
        else
          puts "O protocolo Pai #{parent_prot} Não tem Filho"
        end
      end
    end

    desc "Corrigir Protocolos Filhos Dupicados com os protocolos dos Usuários"
    task :fix_duplicate_child_protocols_with_user_protocols => :environment do |t|
      # Protocolos Pais de Produção:   4000071                           | 4000067
      # Protocolos Filhos de Produção: [protocol: 5158308] (id: 1499903) | [protocol: 5158317] (id: 1499912)
      father_protocols = [
       4000071, 4000067
      ]

      new_son_protocols = [
       4000151, 4000152
      ]

      father_protocols.each_with_index do |prot, index|
        ticket_son_old = Ticket.where("parent_protocol = '#{prot}' AND parent_id IS NOT NULL AND deleted_at IS NULL")
        if !ticket_son_old.empty?
          ticket_son_old = ticket_son_old.first
          ticket_son_new = ticket_son_old.dup

          # Alterando os valores de protocol para o ticket novo
          ActiveRecord::Base.transaction do
            ticket_son_new.protocol = new_son_protocols[index] # alteração necessaria para corrigir duplicidade de protocolos

            # deve ser deletado primeiro devido a unicidade do orgão no model
            ticket_son_old.destroy
            puts "Protocolo Filho Antigo Duplicado com o do Usuário foi Deletado: #{ticket_son_old.protocol}"

            if ticket_son_new.save
              puts "Protocolo Filho Novo Criado: #{ticket_son_new.protocol}"

              # atualizar as tabelas necessárias
              TicketLog.where(ticket_id: ticket_son_old.id).update(ticket_id: ticket_son_new.id)
              puts "Atualizado o campo ticket_id do TicketLog: #{ticket_son_old.protocol} - #{ticket_son_old.id} para #{ticket_son_new.protocol} - #{ticket_son_new.id}"

            end
          end #/ transaction
        else
          puts "O Protocolo Filho não existe #{prot}"
        end
      end
    end #/ task :fix_duplicate_child_protocols_with_user_protocols


    desc "Atualizar Tabela Department para o ticket id Duplicado"
    task :update_duplicate_protocol_ticket_department, [:ticket_id_old, :ticket_id_new] => :environment do |t, args|
      if args.ticket_id_old.present? and args.ticket_id_new.present?
        if Ticket.unscoped.find(args.ticket_id_old)

          ticket_department = TicketDepartment.unscoped.find_by_ticket_id(args.ticket_id_old)

          ticket_department.update(
            ticket_id: args.ticket_id_new.to_i,
            deleted_at: nil
          )

          puts "Atualizado o ticket_id da tabela TicketDepartment"

          ticket_id_after_update = TicketDepartment.find_by_ticket_id(args.ticket_id_new.to_i)

          if !ticket_id_after_update.nil?
            puts "TicketID Anterior #{args.ticket_id_old} | TicketID Atual #{ticket_id_after_update.ticket_id}"
          end
        else
          puts "TicketID Anterior #{args.ticket_id_old}, não encontrado"
        end
      else
        puts 'params incorreto'
      end
    end #/ task :update_duplicate_protocol_ticket_department


    desc "Atualizar Resposta dos Filhos Duplicados para o Novo filho"
    task :update_answer_for_the_new_child_protocol_created => :environment do |t|
      parent_protocols = [4000113, 4000069, 4000106 , 4000012]

      parent_protocols.each do |parent_protocol|
        # Filho Novo
        active_son = Ticket.where("parent_protocol = '#{parent_protocol}' AND parent_id IS NOT NULL AND deleted_at IS NULL")

        # Filho Excluído
        inactive_son = Ticket.unscoped.where("parent_protocol = '#{parent_protocol}' AND parent_id IS NOT NULL AND deleted_at IS NOT NULL")

        if !inactive_son.empty?
          Answer.unscoped.where(ticket_id: inactive_son.first.id).update(
            ticket_id: active_son.first.id,
            deleted_at: nil
          )

          answer = Answer.unscoped.find_by(ticket_id: active_son.first.id )

          if answer
            puts "Resposta Atualizada Protocolo Pai: #{parent_protocol}, Novo TicketId na Resposta: #{answer.ticket_id}"
          end

        else
          puts "Resposta inexistente para o protocol pai #{parent_protocol} e filho #{inactive_son}"
        end
      end
    end #/ task :update_answer_for_the_new_child_protocol_created

    desc "Replicar TicketLogs dos Pais nos Filhos do Protocolo"
    task :replicate_parental_ticket_logs_in_son => :environment do |t|
      parent_protocols = [4000069, 4000106]
      parent_protocols.each do |parent_protocol|
        ticket_father = Ticket.find_by_protocol(parent_protocol)
        if !ticket_father.nil?
          ActiveRecord::Base.transaction do
            # A condição com deleted_at se faz necessária devido possuir filhos inativos (deletados)
            ticket_son = Ticket.where("parent_protocol = '#{parent_protocol}' AND parent_id IS NOT NULL AND deleted_at IS NULL")
            tickets_logs = TicketLog.where(ticket_id: ticket_father.id)

            if !ticket_son.empty? and !tickets_logs.empty?
              tickets_logs.each do |log|
                ticket_log_new = log.dup
                ticket_log_new.ticket_id = ticket_son.first.id
                if ticket_log_new.save
                  puts "TicketLog Filho salvo com sucesso para o Pai: #{parent_protocol}"
                else
                  raise "Erro ao tentar salvar o TicketLog para #{parent_protocol}: Erro: #{ticket_log_new.errors.messages}"
                end
              end
            else
              puts "Filho ou Logs não encontrados para o Pai #{parent_protocol}"
            end
          end #/ ctiveRecord::Base.transaction
        else
          puts "Protocolo Pai não encontrados #{parent_protocol}"
        end
        puts "-------------------------------------------------"
      end #/ parent_protocols.each
    end #/ task :replicate_parental_ticket_logs_in_son


    desc "Atualizar a Classificação do Ticket Pai para o Ticket Filho"
    task :update_father_ticket_classification_for_son_ticket => :environment do |t|
      father_protocols = [4000012, 4000067, 4000110]

      father_protocols.each do |father_protocol|
        ticket_father = Ticket.find_by_protocol(father_protocol)
        ticket_son = Ticket.where("parent_protocol = '#{father_protocol}' AND parent_id IS NOT NULL AND deleted_at IS NULL")

        if ticket_father and !ticket_son.empty?
          Classification.unscoped.where(ticket_id: ticket_father.id).update(
            ticket_id: ticket_son.first.id
          )

          classification =  Classification.find_by_ticket_id(ticket_son.first.id)

          if classification
            puts "TicketId da Classificação atualizado #{classification.ticket_id}, Protocolo Pai #{father_protocol}" if classification.ticket_id == ticket_son.first.id
          else
            puts "Não possui classificação: Protocolo Pai #{father_protocol}"
          end
        else
          puts "Ticket Filho não encontrado para classificação, procotolo Pai #{father_protocol}"
        end
      end #/ father_protocols.each
    end #/ task :update_father_ticket_classification_for_son_ticket


    desc "Atualizar a classificaçao para o TicketId do protocolo Filho Novo"
    task :update_the_classification_for_the_new_son_protocol_ticket_id => :environment do |t|
      parent_protocols = [4000069, 4000106]

      parent_protocols.each do |parent_protocol|
        # Filho Novo
        active_son = Ticket.where("parent_protocol = '#{parent_protocol}' AND parent_id IS NOT NULL AND deleted_at IS NULL")

        # Filho Excluído
        inactive_son = Ticket.unscoped.where("parent_protocol = '#{parent_protocol}' AND parent_id IS NOT NULL AND deleted_at IS NOT NULL")

        if !inactive_son.empty? and !active_son.empty?
          ActiveRecord::Base.transaction do
            Classification.unscoped.where(ticket_id: inactive_son.first.id).update(
              ticket_id: active_son.first.id,
              deleted_at: nil
            )

            classification =  Classification.find_by_ticket_id(active_son.first.id)

            if classification
              puts "TicketId da Classificação atualizado #{classification.ticket_id}, Protocolo Pai #{parent_protocol}" if classification.ticket_id == active_son.first.id
            else
              puts "Não possui classificação: Protocolo Pai #{parent_protocol}"
            end
          end
        else
          puts "Ticket Filho não encontrado para classificação, procotolo Pai #{parent_protocol}"
        end
      end #/ parent_protocols.each
    end #/ task :update_the_classification_for_the_new_son_protocol_ticket_id

################################################ 26-04-2019 ##############################################

    desc "Atualizar o status para Respondido e o internal_status para Resposta Final"
    task :update_status_and_internal_status => :environment do |t|
      parent_protocol = 4000126
      son_protocol = 5151689
      replied = Ticket.statuses['replied']
      final_answer = Ticket.internal_statuses['final_answer']

      father_ticket = Ticket.find_by_protocol(parent_protocol) # Somente quando o filho não possui a informação do pai

      if father_ticket
        Ticket.where(
          protocol: son_protocol
        ).update(
          status: replied,
          internal_status: final_answer,
          deadline: father_ticket.deadline, # Somente quando o filho não possui a informação do pai
          deadline_ends_at: father_ticket.deadline_ends_at # Somente quando o filho não possui a informação do pai

        )
        puts "Protocolo Atualizado #{parent_protocol}"
      end
    end #/ task :update_status_and_internal_status

    desc "Atualizar a resposta que esta no Ticket Pai para o Ticket Filho"
    task :update_response_from_parent_to_son => :environment do |t|
      # Protocolo Pai: 4000110
      parent_protocol = 4000110
      id_parent_protocol = 1494339
      id_son_protocol = 1499907

      Answer.where(
        ticket_id: id_parent_protocol
      ).update(
        ticket_id: id_son_protocol
      )
      puts "Resposta Atualizada: Protocolo #{parent_protocol} - ID do Pai: #{id_parent_protocol} | ID do Filho #{id_son_protocol}"


      # Apenas se precisar atualizar para atendimento setorial, utilize o código abaixo
      puts " -------------------------- Adicionando em Atendimento Setorial --------------------------"

      Ticket.where(id: id_parent_protocol).update(internal_status: Ticket.internal_statuses['sectoral_attendance'])
      puts "Atualizado o campo internal_status do Pai: ID #{id_parent_protocol}"
      Ticket.where(id: id_son_protocol).update(internal_status: Ticket.internal_statuses['sectoral_attendance'])
      puts "Atualizado o campo internal_status do Filho: ID #{id_son_protocol}"
    end #/ task :update_response_from_parent_to_son

    desc "Atualizar Orgão do Ticket"
    task :update_organ => :environment do |t|

      parent_protocols = [4000129, 4000130]
      organ_id = 14 # CGE
      parent_protocols.each do |parent_protocol|
        Ticket.where(
          protocol: parent_protocol
        ).update(
          organ_id: organ_id,
          unknown_organ: false # so permite setar o organ_id se atualizar esta flag
        )
        puts "Orgão Atualizado com para o protocolo #{parent_protocol}"
        puts "---------------------------------------------------------"
      end #/ parent_protocols.each
    end #/ task :update_organ

    desc "Atualizar Prazo do Ticket"
    task :update_deadline => :environment do |t|

      protocols = [5151662,5151665,5151686]
      deadline = 5
      deadline_ends_at = '2019-04-15'
      protocols.each do |protocol|
        Ticket.where(
          protocol: protocol
        ).update(
          deadline: deadline,
          deadline_ends_at: deadline_ends_at
         )
        puts "Prazo Atualizado com para o protocol #{protocol}"
        puts "---------------------------------------------------------"
      end #/ parent_protocols.each
    end #/ task :update_deadline

    desc "Corrigindo Protocolos da SEDUC que passaram por Aprovação e estam com o Internal Status errado"
    task :seduc_protocols_with_wrong_in_internal_status  => :environment  do |t|
      # organ_id 43 é SEDUC
      # answers_status 4, resposta aprovada pela CGE (:cge_approved)
      # internal_status NOT IN (8,9) = 8 finalizada, 9 invalidada


      # Na tabela de Answers só possui protocolos Filhos
      tickets = Ticket.joins(:answers).where("
        organ_id = 43
        AND answers.status = 4
        AND answers.created_at <= '21-10-2019'
        AND internal_status NOT IN (8,9)
      ")

      tickets.each do |ticket|
        begin
          ApplicationRecord.transaction do
            puts "[   Iniciada Atualização para Ticket Filho: #{ticket.id}    "
            update_ticket(ticket)
            puts "    -- Internal Status Final: #{ticket.internal_status}  --     "
            puts "    Finalizada Atualização para Ticket Filho: ID #{ticket.id}"
            puts ""
            puts "    Iniciada Atualização para Ticket Pai: ID #{ticket.parent.id}"
            update_ticket(ticket.parent, ticket)
            puts "    -- Internal Status Final: #{ticket.parent.internal_status}  --     "
            puts "    Finalizada Atualização para Ticket Pai: ID #{ticket.parent.id}"
            puts "]"
            puts ""
          end #/ ApplicationRecord
        rescue => e
          puts "::::::::::::::::: RELATÓRIO DE ERROS :::::::::::::::::"
          puts ""
          # se eu nao consultar o Ticket novamente, ele não pega o valor correto
          puts "    -- Internal Status Final Filho: #{Ticket.find(ticket.id).internal_status}  --     "
          puts "    -- Internal Status Final PAI: #{Ticket.find(ticket.parent.id).internal_status}  --     "
          puts "    -- Ticket NÃO Atualizado: #{ticket.id}  --     "
          puts "    -------------------------- ERRO: #{e.inspect} --------------------------  "
          puts "]"
          puts ""
        end #/ begin
      end #/ tickets.each
    end #/ :seduc_protocols_with_wrong_in_internal_status

    desc 'Corrigindo Protocolos com prazos negativos grupo com status finalizadas'
    task :fix_negative_scope_only_finalized => :environment  do |t|
      count = 0

      scope = Ticket.where("ticket_type = 1 AND internal_status = 8 AND deadline < ? AND reopened_at IS NULL AND extended = FALSE", 0)

      scope.each { |ticket|
        if child_with_response_final_and_without_parcial?(ticket) && 
          ticket.deadline != ticket.answers.max.deadline && 
          !ticket.answers.max.deadline.nil? && !ticket.deadline.nil?

          ticket_deadline_base = ticket.deadline # guardando o estado antigo do deadline, para o output console

          # ignora de a diferença de dias for entre -2 a 2, devido furo no deadline da tabela answers.
          unless difference_ignored?(difference_deadline(ticket))
            if check_deadlines?(ticket)
              calculated_deadline = ticket.deadline
            else
              calculated_deadline = ticket.answers.max.deadline
            end
            
            if calculated_deadline != ticket.deadline
              count += 1
              
              ticket.update_attribute(:deadline, calculated_deadline)

              base_message(ticket, ticket_deadline_base, calculated_deadline, count)
            end
          end
        elsif ticket.parent?
          parent_last_answer = nil
          ticket_deadline_base = ticket.deadline # guardando o estado antigo do deadline, para o output console

          ticket.tickets.each do |ticket_child|
            if child_with_response_final_and_without_parcial?(ticket_child)
              parent_last_answer = ticket_child.answers.max if parent_last_answer.nil? || 
              is_last_answer_between_children?(ticket_child.answers.max, parent_last_answer)
            end
          end

          if !parent_last_answer.nil? && !parent_last_answer.deadline.nil?
            # usando ticket, devido o ticket que sofrerá atualização ser o Pai
            unless difference_ignored?(difference_deadline(ticket, parent_last_answer))
              calculated_deadline = parent_last_answer.deadline
              
              if calculated_deadline != ticket.deadline
                count += 1
              
                ticket.update_attribute(:deadline, calculated_deadline)
              
                base_message(ticket, ticket_deadline_base, calculated_deadline, count)
              end
            end
          end
        end
      }
    end

    desc 'Adicionando para todos os tickets o valor de update_internal_evaluation e marked_internal_evaluation como false'
    task update_internal_evaluation_and_marked_internal_evaluation: :environment  do |t|
      puts '#### Início da execução ####'

      Ticket.unscoped.in_batches(of: 1000).update_all(
        internal_evaluation: false,
        marked_internal_evaluation: false
      )

      puts '#### Finalizou a execução ####'
    end

    def difference_deadline(ticket, parent_last_answer=nil)
      if parent_last_answer.nil?
        (ticket.answers.max.deadline - ticket.deadline)
      elsif !parent_last_answer.deadline.nil?
        (parent_last_answer.deadline - ticket.deadline)
      end
    end

    def check_deadlines?(ticket)
      (difference_created_at_answer_and_deadline_ends_at(ticket) == ticket.deadline) || 
      (difference_updated_at_ticket_log_and_deadline_ends_at(ticket) == ticket.deadline)
    end

    def difference_created_at_answer_and_deadline_ends_at(ticket)
      (ticket.answers.max.created_at.to_date - ticket.deadline_ends_at.to_date).to_i * (-1)
    end

    def difference_updated_at_ticket_log_and_deadline_ends_at(ticket)
      ticket_log = ticket.ticket_logs.where(action: [14, 24] ).max

      (ticket_log.created_at.to_date - ticket.deadline_ends_at.to_date).to_i * (-1)
    end

    # devido a tabela de resposta está com furo sem o uso dos finais de semanas na criação do ticket e feriados
    def difference_ignored?(difference_deadline)
      difference_deadline >= -2 and difference_deadline <= 2
    end


    def base_message(ticket, ticket_deadline_base, calculated_deadline, count)
      text_for_child = "| Pai: #{ticket.parent_protocol} | Orgão: #{ticket.organ.acronym}" if ticket.child?

      puts "[--- Seq: #{count} | Protocolo Atualizado: #{ticket.protocol} #{text_for_child} ---]"
      puts "Prazo Calculado e atualizado: #{calculated_deadline}"
      puts "Prazo anterior na base: #{ticket_deadline_base}"
      puts ""
    end

    def child_with_response_final_and_without_parcial?(ticket)
      answers_types = ticket.answers.pluck(:answer_type)
      ticket.child? && (answers_types.include?('final') && answers_types.exclude?('partial'))
    end

    def is_last_answer_between_children?(current_ticket_answer, parent_last_answer)
      current_ticket_answer.created_at > parent_last_answer.created_at
    end

    # recebe o ticket que deve ser atualizado e no caso deste ser Pai também recebe 
    # o Filho da iteração (da vez), para atualizar os campos internal_status e responded_at que
    # vem da tabela de Resposta seu valor, obs.: o Pai não possui resposta.
    def update_ticket(ticket, ticket_child = nil)
      puts "    -- Internal Status Inicial: #{ticket.internal_status}  --     "

      # Devido os protocolos filhos que possui resposta final possuirem apenas
      # um filho, o seu answer_type será aplicado direto no pai.
      ticket.update_attributes(
        status: :replied,
        internal_status: internal_status_value(ticket, ticket_child),
        responded_at: updated_at_value(ticket, ticket_child)
      )
    end

    def internal_status_value(ticket, ticket_child)
      if ticket.parent?
        Ticket.internal_statuses[:"#{ticket_child.answers.last.answer_type}_answer"]
      else
        Ticket.internal_statuses[:"#{ticket.answers.last.answer_type}_answer"]
      end
    end

    def updated_at_value(ticket, ticket_child)
      if ticket.parent?
        ticket_child.answers.last.updated_at
      else
        ticket.answers.last.updated_at
      end
    end

	end #/ namespace :maintenance
end #/ namespace :tickets