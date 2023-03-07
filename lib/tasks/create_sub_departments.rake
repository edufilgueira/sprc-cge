namespace :create_sub_departments do
  task create_or_update: :environment do

    ### informe o diretorio dos arquivos
    files = Dir["/home/sprc/planilhas/department_sub_department/*.xls"]

    puts "Nenhuma planilha encontrada" if files.nil? || files.blank?

    files.each { |file|
      xls = Roo::Spreadsheet.open(file)
      xls.default_sheet = xls.sheets.first
      (2..xls.last_row).map do |row|

        name = xls.cell(row, 5)
        acronym = xls.cell(row, 6).to_s.strip.upcase
        acronym_department = xls.cell(row, 4).to_s.strip.upcase
        acronym_organ = xls.cell(row, 1).to_s.strip.upcase

        next if acronym == 'Sigla da subunidade' || acronym == nil || acronym == ''

        organ = Organ.find_by(acronym: acronym_organ)
        department = Department.find_by(acronym: acronym_department, organ: organ)

        if department.nil?
          puts "ERROR: department_acronym: #{acronym_department} - acronym: #{acronym} - file: #{File.basename(file)}"
          next
        end

        SubDepartment.find_or_create_by(name: name,
          acronym: acronym,
         department: department)
      end
    }
  end
end
