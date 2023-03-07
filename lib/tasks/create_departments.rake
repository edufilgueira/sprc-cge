namespace :create_departments do
  task create_or_update: :environment do

    ### informe o diretorio dos arquivos
    files = Dir["/home/sprc/planilhas/department_sub_department/*.xls"]

    puts "Nenhuma planilha encontrada" if files.nil? || files.blank?

    last_acronym = ''

    files.each do |file|
      xls = Roo::Spreadsheet.open(file)
      xls.default_sheet = xls.sheets.first
      (2..xls.last_row).map do |row|
        name = xls.cell(row, 3)
        acronym = xls.cell(row, 4).to_s.strip.upcase
        acronym_organ = xls.cell(row, 1).to_s.strip.upcase

        next if last_acronym == acronym || acronym == 'Sigla da Unidade' || acronym == nil || acronym == ''

        organ = Organ.find_by(acronym: acronym_organ)

        if organ.nil?
          puts "ERROR: organ_acronym: #{acronym_organ} - acronym: #{acronym} - file: #{File.basename(file)}"
          next
        end

        Department.find_or_create_by(name: name,
          acronym: acronym,
          organ: organ)

        last_acronym = acronym
      end
    end

    # XXX
    # XXX Chumbando para classificação de manifestações da COSCO
    # XXX

    department_data = [
      {
        name: 'Comissão Permanente de Apuração de Denúncias',
        acronym: 'COSCO',
        organ: Organ.find_by(acronym: 'COSCO')
      }
    ]

    department_data.each do |department_data|
      Department.find_or_create_by(name: department_data[:name],
          acronym: department_data[:acronym],
          organ: department_data[:organ])
    end

  end
end
