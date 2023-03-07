namespace :tickets do
  namespace :sic do

    # rake tickets:sic:anual_export:create 2018, 2019, 2020
    namespace :anual_export do

      desc 'Exporta os dados anuais do SIC. Planilha e Anexos'

      task create:  :environment do |t, args|
        create_csv('ticket')
        create_csv('answer')
        create_csv('reopen')
        export_attachments
        puts 'Fim do processamento'
      end

      def create_csv(type)
        create_directory(csv_directory)
        CSV.open(send("#{type}_filepath"), 'wb') do |csv|
          header = send("#{type}_columns")

          if type == 'reopen'
            header << 'parent_protocol'
          end

          csv << header
          add_rows_to_file(csv, type)
        end
      end

      # Pesquisa registros e adiciona ao csv
      def add_rows_to_file(csv, type)
        years_to_export.each do |year|
          puts "adicionando #{humanize(type.to_sym)} do ano #{year} favor aguarde ..."

          @year = year
          send("#{type}s").find_in_batches do |rows|
            rows.pluck(
              *send("#{type}_columns")
            ).each { |ticket|

              if type == 'reopen'
                ticket = version_search(ticket)
                ticket << parent_protocol(ticket)
              end

              csv << sanitize(ticket) 
            }
          end

        end                 
      end

      # Primeiro dia do Ano corrente no laço de importação
      def start_of_year 
        Date.new(@year.to_i, 1, 1)
      end

      # Ultimo dia do Ano corrente no laço de importação
      def end_of_year
        start_of_year.end_of_year.to_datetime.end_of_day
      end

      # Captura os anos passados como parametros no shell
      def years_to_export
        years = []
        ARGV.each { |a| task a.to_sym do ; end }
        ARGV.each_with_index do |year, index| 
          next if index == 0
          years << year
        end
        years
      end

      # Escopo dos tickets
      def tickets
        Ticket.sic.final_answer
          .where(created_at: start_of_year..end_of_year)
          .where.not(organ_id: nil) # tem que ter orgao associado
      end

      # Escopo das Respostas
      def answers
        Answer.where(ticket_id: tickets.pluck(:id))
      end

      # Escopo das Reaberturas
      def reopens
        # os dados das reaberturas constam na tabela de TicketLog
        TicketLog.where(ticket_id: tickets.pluck(:id), action: 7)
      end

      # File Path do CSV
      def ticket_filepath
        Rails.root.to_s + "/public/files/downloads/sic_anual_export/solicitacoes.csv"
      end

      # File Path do CSV
      def answer_filepath
        Rails.root.to_s + "/public/files/downloads/sic_anual_export/respostas.csv"
      end

      # File Path do CSV
      def reopen_filepath
        Rails.root.to_s + "/public/files/downloads/sic_anual_export/reaberturas.csv"
      end

      # Diretório do CSV
      def csv_directory
        File.dirname(ticket_filepath)
      end

      # Diretório dos Attahments
      def attachment_directory
        File.dirname(ticket_filepath).concat("/anexos")
      end

      # Verifica se o diretório do file_path é de ..\anexos e se existe, caso sim remove
      # e mais adiante cria vazio.
      # Depois verifica se o diretório do file_path existe e cria, caso exista ignora
      def create_directory(path)
        FileUtils.rm_rf(path) if (File.directory?(path) and path.include?'anexos')

        FileUtils.mkdir_p(path) unless File.directory?(path)
      end

      # Colunas do CSV ticket
      def ticket_columns
        [
          'id',
          'protocol',
          'created_at',
          'description', # Coluna sanitizada pela posição, se mudar alterar methodo
          'parent_protocol'
        ]
      end

      # Colunas do CSV answer
      def answer_columns
        [
          'id',
          'ticket_id',
          'created_at',
          'description',
          'version'
        ]
      end

      # Colunas do CSV reopen
      def reopen_columns
        [
          'id', # o id da reabetura é o próprio id do ticket_log, pois não existe uma tabela de reabertura
          'ticket_id',
          'created_at',
          'description',
          'data' # a versão da reabertura esta dentro do data[:count]
        ]
      end

      def humanize(type)
        {
          ticket: 'solicitacao',
          answer: 'resposta',
          reopen: 'reabetura'
        }[type]
      end

      # Remove codigos html das descrições
      def sanitize(ticket)
        ticket[3] = sanitize_html(ticket[3])
        ticket
      end

      # Remove codigos html das descrições
      def sanitize_html(html_text)
        ActionView::Base.full_sanitizer.sanitize(html_text)
      end

      # O anexo pode estar no ticket pai ou no filho
      # ambos arquivos devem ser colocados no Path com id do filho
      # o path tem id do filho e reune arquivos dele e do seu pai

      def export_attachments
        puts "Gerando Anexos favor aguardar"
        
        create_directory(attachment_directory) # raiz do attachment
        years_to_export.each do |year|
          @year = year # Os scopos usam @year

          
          tickets.find_in_batches do |rows|
            rows.each do |ticket_son|
              # copiando anexos do ticket filho
              each_attachments_and_copy(ticket_son, ticket_son.id)

              # Também precisa iterar os atachments 
              # do Pai e colocar na pasta do filho
              each_attachments_and_copy(ticket_son.parent, ticket_son.id)

              # Copiando anexos de respota]
              ticket_son.answers.each do |answer|
                each_attachments_and_copy(answer, answer.id)
              end
            end
          end
        end
      end

      # Itera os anexos de um objeto attachmentable (com anexos) ,
      # e solicita copia dos anexos
      def each_attachments_and_copy(attachmentable, id_reference)
        attachmentable.attachments.each do |attachment|
          attachment_copy(attachment, id_reference)
        end
      end

      # Pega o path do arquivo atachado no filesystem do ct (padrão refile)
      def get_path_from_attachment(row)
        Rails.root.to_s + "/public/files/uploads/store/" + row.document_id
      end

      # Monta o path de destino dos arquivos
      def new_attachment_path(type, attachmentable_id)
        attachment_directory + "/#{humanize(type.downcase.to_sym)}/#{attachmentable_id}/"
      end

      # Prepara e chama função que copia fisicamente
      def attachment_copy(attachment, id_reference)
        attachment_copy_file( 
          get_path_from_attachment(attachment),
          new_attachment_path(attachment.attachmentable_type, id_reference),
          attachment.document_filename
        )
      end

      # Cria diretório e copia fisicament um arquivo
      def attachment_copy_file(original_path, new_path, filename)
        if File.exist?(original_path)
          create_directory(new_path)
          FileUtils.cp(original_path, new_path + filename)
        end
      end

      # encontra a versão da reabertura
      def version_search(ticket)
        ticket[4] = ticket.last[:count]

        ticket
      end

      def parent_protocol(ticket)
        Ticket.find(ticket[1]).parent_protocol
      end

    end
  end
end