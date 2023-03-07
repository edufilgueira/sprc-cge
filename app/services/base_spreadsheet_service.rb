##
# Métodos compartilhados pelos geradores de planilhas
#
##

class ::BaseSpreadsheetService

  attr_reader :worksheets

  def initialize(spreadsheet_object=nil)
    # guarda a contagem de títulos repetidos pois não deve ter
    # 2 worksheets com mesmo nome.
    @worksheet_titles = nil

    @worksheets = {}
  end

  def spreadsheet_dir_path
    spreadsheet_object.dir_path
  end

  def spreadsheet_file_path
    spreadsheet_object.file_path
  end

  def create_dir
    FileUtils.rm_rf(spreadsheet_dir_path) if File.exist?(spreadsheet_dir_path)
    FileUtils.mkdir_p(spreadsheet_dir_path)
  end

  def finish_spreadsheet
    xls_package.serialize(spreadsheet_file_path)
  end

  def spreadsheet_object_symbol
    spreadsheet_object.class.name.underscore
  end

  def worksheet_title(worksheet_type)
    I18n.t("#{spreadsheet_object_symbol}.spreadsheet.worksheets.#{worksheet_type}.title")
  end

  ## XLS

  def xls_package
    @xls_package ||= ::Axlsx::Package.new
  end

  def xls_workbook
    @xls_workbook ||= xls_package.workbook
  end

  def xls_add_worksheet(worksheet_type)
    worksheet_title = sanitized_worksheet_title(worksheet_type)

    xls_workbook.add_worksheet(name: worksheet_title) do |sheet|
      unless worksheet_type == :summary
        xls_add_header(sheet, header(worksheet_type))
      end

      yield sheet
    end
  end

  def xls_add_header(sheet, header)
    sheet.add_row(header, style: xls_default_header_style(sheet))
  end

  def xls_add_row(sheet, row, styles=nil, widths=nil)
    styles = apply_cell_style(sheet, styles)
    sheet.add_row(row, style: styles, widths: widths)
  end

  def xls_add_empty_rows(sheet, count=1)
    count.times do
      sheet.add_row []
    end
  end

  def apply_cell_style(sheet, style)
    return style_default(sheet) if style.nil?

    styles = []
    style.each do |s|
      styles.push( send("style_#{s}",sheet) )
    end
    style.present? ? styles : style_default(sheet)
  end

  def style_default(sheet)
    @xls_default ||=
      sheet.styles.add_style({
        border: xls_default_border_style,

        alignment: {
          vertical: :top
        }
      })
  end

  def style_bold(sheet)
    @xls_bold ||=
      sheet.styles.add_style({
        border: xls_default_border_style,

        alignment: {
          vertical: :top
        },

        b: true
      })
  end

  def style_bold_percent(sheet)
    @xls_bold_percent ||=
      sheet.styles.add_style({
        border: xls_default_border_style,
        format_code: "0.00%",

        alignment: {
          vertical: :top
        },

        b: true
      })
  end

  def style_percent(sheet)
    @style_percent ||=
      sheet.styles.add_style({
        border: xls_default_border_style,
        format_code: "0.00%",

        alignment: {
          vertical: :top
        }
      })
  end

  def xls_default_header_style(sheet)
    @xls_default_header_style ||=
      sheet.styles.add_style({
        border: xls_default_border_style,

        alignment: {
          vertical: :center
        },

        bg_color: 'FFF0F0F0',
        fg_color: 'FF000000',
        b: true
      })
  end

  def xls_default_border_style
    { style: :thin, color: 'FF000000' }
  end

  def xls_worksheet(worksheet_type)
    if worksheets[worksheet_type].blank?
      xls_add_worksheet(worksheet_type) do |sheet|
        worksheets[worksheet_type] = sheet
        yield worksheets[worksheet_type]
      end
    else
      yield worksheets[worksheet_type]
    end
  end

  #
  # Os nomes devem ter menos de 31 caraceteres e não pode ser repetidos.
  def sanitized_worksheet_title(worksheet_type)
    title = worksheet_title(worksheet_type)
    sliced_title = title.slice(0, 25)

    initialize_worksheet_titles

    @worksheet_titles[sliced_title] = 0 if @worksheet_titles[sliced_title].blank?

    existing_count = (@worksheet_titles[sliced_title] += 1)

    if (existing_count > 1)
      new_title = "#{sliced_title}_#{existing_count + 1}"
      return new_title
    end

    sliced_title
  end

  def initialize_worksheet_titles
    if @worksheet_titles.blank?
      @worksheet_titles = {}
      xls_workbook.worksheets.each do |sheet|
        @worksheet_titles[sheet.name] = 1
      end
    end
  end
end
