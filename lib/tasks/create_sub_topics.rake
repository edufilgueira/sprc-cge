namespace :create_sub_topics do
  task create_or_update: :environment do

    ### informe o diretorio dos arquivos
    files = Dir["/home/sprc/planilhas/topics_sub_topics/*.xls"]

    puts "Nenhuma planilha encontrada" if files.nil? || files.blank?

    files.each do |file|
      xls = Roo::Spreadsheet.open(file)
      xls.default_sheet = xls.sheets.first
      (2..xls.last_row).map do |row|

        name = xls.cell(row, 4)
        name_topic = xls.cell(row, 3)
        acronym_organ = xls.cell(row, 1).to_s.strip.upcase

        next if name == 'Nome do Subassunto' || name == nil || name == ''

        organ = Organ.find_by(acronym: acronym_organ)
        topic = Topic.find_by(name: name_topic, organ: organ)

        if topic.nil?
          puts "ERROR: organ_acronym: #{acronym_organ} - topic_name: #{name_topic} - name: #{name} - file: #{File.basename(file)}"
          next
        end

        Subtopic.find_or_create_by(name: name, topic: topic)
      end
    end

    # XXX
    # XXX Chumbando para classificação a pedido da CGE
    # XXX
    subtopics_data = [
      {
        name: 'Outros',
        other_organs: true,
        topic: Topic.find_by(name: 'Não compete ao Poder Executivo Estadual')
      }
    ]

    subtopics_data.each do |subtopic_data|
      subtopic = Subtopic.find_or_initialize_by(name: subtopic_data[:name])

      subtopic.update_attributes!(subtopic_data)
    end
  end
end
