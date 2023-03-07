class Operator::CreateSpreadsheet

  attr_accessor :result, :transparency_export, :logger

  def self.call(export_id)
    new(export_id).call
  end
  
  def initialize(export_id)
    @transparency_export = Transparency::Export.find(export_id)
    
    @logger = Logger.new(log_path) if @logger.nil?
    
    @result = transparency_export.resource.find_by_sql(transparency_export.query)
  end
  
  def call
    transparency_export.in_progress!
    
    log(:info, "[TransparencyExport] Export ##{transparency_export.id} in progress")
    
    create_file

    update_transparency_export

    send_email
  end


  # Private

  private

  def presenter_klass
    "Operator::Export::#{transparency_export.camelized_resource}Presenter".constantize
  end

  def columns 
    presenter_klass.spreadsheet_header
  end

  def row(resource)
    presenter_klass.new(resource).spreadsheet_row
  end

  def rows(resources)
    presenter_klass.new(resources).spreadsheet_row
  end

  def filtered_resources
    # em alguns resources (servidores, contratos..) o 'id' é o alias 't0_r0'.
    # os testes devem garantir que seja sempre 't0_r0'
    ids = result.pluck(:id).first.present? ? result.pluck(:id) : result.map(&:t0_r0)

    transparency_export.resource.where(id: ids)
  end

  def create_file
    #return if transparency_already_created.present?
    
    create_dir
    
    log(:info, "[TransparencyExport] Export ##{transparency_export.id} creating file")
    
    send("create_#{extension}")

    log(:info, "[TransparencyExport] Export ##{transparency_export.id} file created")
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
  
  def create_csv
    CSV.open(filepath, 'w') do |csv|
      csv << columns
      add_rows_to_file(csv)
    end
  end
  
  def add_rows_to_file(sheet)
    filtered_resources.find_each do |resource|
      row = row(resource)
      send("add_row_to_#{extension}", sheet, row)
    end
  end

  def add_row_to_xlsx(sheet, data)
    sheet.add_row data
  end

  def add_row_to_csv(csv, data)
    csv << data
  end

  def update_transparency_export
    status = file_present? ? 'success' : 'error'

    expiration = Date.today + Transparency::Export::DEADLINE_EXPIRATION if file_present?

    transparency_export.update(filename: filename, status: status, expiration: expiration)

    log(:info, "[TransparencyExport] Export ##{transparency_export.id} updated")
  end

  def send_email
    status = transparency_export.status

    Transparency::ExportMailer.send("spreadsheet_#{status}", transparency_export).deliver

    log(:info, "[TransparencyExport] Export ##{transparency_export.id} e-mail delivered")
  end

  def file_present?
    File.exist?(filepath)
  end

  def dirpath
    transparency_export.dirpath
  end

  def extension
    transparency_export.worksheet_format
  end

  def filename
    return build_filename
  end

  def build_filename
    @build_filename ||= "#{transparency_export.id}_#{transparency_export.underscored_resource}.#{extension}"
  end

  def filepath
    transparency_export.filepath(filename)
  end

  def create_dir
    FileUtils.mkdir_p(dirpath)
  end

  def transparency_already_created
    params = {
      query: @transparency_export.query,
      status: ['success', 'in_progress', 'queued'],
      worksheet_format: @transparency_export.worksheet_format,
      created_at: (Date.today.beginning_of_day..Date.today.end_of_day)
    }

    #
    # CUIDADO: é obrigatório que o arquivo considerado seja um que já foi criado e que já esteja sendo processado
    # senão entramos no looping infinito
    #
    Transparency::Export.where.not('id >= ?', @transparency_export.id).find_by(params)
  end

  def log(type, message)
    @logger.send(type, message)
  end

  def log_path
    if Rails.env.test?
      Rails.root.to_s + '/log/test_transparency_export.log'
    else
      Rails.root.to_s + '/log/transparency_export.log'
    end
  end
end
