namespace :create_topics do
  task create_or_update: :environment do

    ### informe o diretorio dos arquivos
    files = Dir["/home/sprc/planilhas/topics_sub_topics/*.xls"]

    puts "Nenhuma planilha encontrada" if files.nil? || files.blank?

    last_name = ''
    last_organ = ''

    files.each do |file|
      xls = Roo::Spreadsheet.open(file)
      xls.default_sheet = xls.sheets.first
      (2..xls.last_row).map do |row|

        name = xls.cell(row, 3)
        acronym_organ = xls.cell(row, 1).to_s.strip.upcase

        next if (last_name == name && last_organ == acronym_organ) ||
          name == 'Nome do Assunto' || name == nil || name == ''

        acronym_organ = nil if acronym_organ == "TODOS"

        unless acronym_organ.nil?
          organ = Organ.find_by(acronym: acronym_organ)

          if organ.nil?
            puts "ERROR: organ_acronym: #{acronym_organ} - name: #{name} - file: #{File.basename(file)}"
            next
          end
        end

        created = Topic.find_or_create_by(name: name, organ: organ)

        last_name = name
        last_organ = acronym_organ
      end
    end

    # XXX
    # XXX Chumbando para classificação a pedido da CGE
    # XXX
    topics_data = [
      {
        name: 'Não compete ao Poder Executivo Estadual',
        other_organs: true
      }
    ]

    topics_data.each do |topic_data|
      topic = Topic.find_or_initialize_by(name: topic_data[:name])

      topic.update_attributes!(topic_data)
    end
  end
end
