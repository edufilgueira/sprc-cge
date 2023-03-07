#
# Serviço de geração de planilhas das pesquisa de avaliação de serviço publico
#
#
class ServicesRatingExport::CreateSpreadsheet

  attr_accessor :services_rating_export

  def self.call(services_rating_export_id)
    new(services_rating_export_id).call
  end

  def initialize(services_rating_export_id)
    @services_rating_export = ServicesRatingExport.find services_rating_export_id
  end

  def call
    services_rating_export.in_progress!

    create_file
  end


  # private

  private

  def create_file
    create_dir

    send("create_#{extension}")

    update_services_rating_export
  end

  def create_csv
    CSV.open(filepath, 'w') do |csv|
      csv << columns
      add_rows_to_file(csv)
    end
  end

  def create_xlsx
    p = Axlsx::Package.new
    p.workbook.add_worksheet do |sheet|
      sheet.add_row columns
      add_rows_to_file(sheet)
    end
    p.use_shared_strings = true
    p.serialize(filepath)
  end

  def columns
    ['Data', 'Sugestão']
  end

  def add_rows_to_file(format)
    ServicesRating.where(created_at: start_at..ends_at).find_each do |sr|
      description = ServicesRating.human_attribute_name("description.#{sr.description}")
      data = [I18n.l(sr.created_at.to_date, format: :default), description]
      send("add_row_to_#{extension}", format, data)
    end
  end

  def add_row_to_xlsx(sheet, data)
    sheet.add_row data
  end

  def add_row_to_csv(csv, data)
    csv << data
  end

  def start_at
    services_rating_export.start_at.beginning_of_day
  end

  def ends_at
    services_rating_export.ends_at.end_of_day
  end

  def create_dir
    FileUtils.mkdir_p(dirpath)
  end

  def extension
    services_rating_export.worksheet_format
  end

  def filename
    title = 'services_rating'

    @filename ||= "#{services_rating_export.id}_#{title}.#{extension}"
  end

  def filepath
    services_rating_export.filepath(filename)
  end

  def dirpath
    services_rating_export.dirpath
  end

  def update_services_rating_export
    status = File.exist?(filepath) ? 'success' : 'error'
    services_rating_export.update(filename: @filename, status: status)
  end
end
