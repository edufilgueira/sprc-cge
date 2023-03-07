#
# Serviço de geração de planilhas das pesquisa de satisfação de transparência
#
# XXX não internacionalizado por ser uma ferramanta administrativa
#
class SurveyAnswerExport::CreateSpreadsheet

  attr_accessor :survey_answer_export

  def self.call(survey_answer_export_id)
    new(survey_answer_export_id).call
  end

  def initialize(survey_answer_export_id)
    @survey_answer_export = SurveyAnswerExport.find survey_answer_export_id
  end

  def call
    survey_answer_export.in_progress!

    create_file
  end


  # private

  private

  def create_file
    create_dir

    send("create_#{extension}")

    update_survey_answer_export
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
    ['Data', 'Satisfação', 'Email', 'Mensagem', 'Url']
  end

  def add_rows_to_file(format)
    Transparency::SurveyAnswer.where(created_at: start_at..ends_at).find_each do |sa|
      answer = Transparency::SurveyAnswer.human_attribute_name("answer.#{sa.answer}")
      data = [I18n.l(sa.date), answer, sa.email, sa.message, sa.url]
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
    survey_answer_export.start_at.beginning_of_day
  end

  def ends_at
    survey_answer_export.ends_at.end_of_day
  end

  def create_dir
    FileUtils.mkdir_p(dirpath)
  end

  def extension
    survey_answer_export.worksheet_format
  end

  def filename
    title = 'transparency_survey_answer'

    @filename ||= "#{survey_answer_export.id}_#{title}.#{extension}"
  end

  def filepath
    survey_answer_export.filepath(filename)
  end

  def dirpath
    survey_answer_export.dirpath
  end

  def update_survey_answer_export
    status = File.exist?(filepath) ? 'success' : 'error'
    survey_answer_export.update(filename: @filename, status: status)
  end
end
