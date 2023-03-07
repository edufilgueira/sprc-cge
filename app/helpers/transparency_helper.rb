module TransparencyHelper

  def transparency_select_options_from_model(model, attribute)
    model.distinct(attribute).pluck(attribute).uniq.compact.sort
  end

  def transparency_open_data_spreadsheet_download_path(filename)
    download_path = "/files/downloads/integration/open_data/#{filename}"

    file_path = Rails.root.join('public', 'files', 'downloads', 'integration', 'open_data', "#{filename}")

    File.exists?(file_path) ? download_path : nil
  end

  def transparency_spreadsheet_download_path(transparency_area, transparency_file_prefix, year, month, extension)
    if month.is_a?(String)
      range = month.split('-')
      year_month = "#{year}_#{range.first}_#{range.last}"
    elsif month > 0
      date = Date.new(year, month)
      year_month = l(date, format: "%Y%m")
    else
      year_month = year.to_s
    end

    download_path = "/files/downloads/integration/#{transparency_area}/#{year_month}/#{transparency_file_prefix}_#{year_month}.#{extension}"

    file_path = Rails.root.join('public', 'files', 'downloads', 'integration', transparency_area.to_s, year_month, "#{transparency_file_prefix}_#{year_month}.#{extension}")

    File.exists?(file_path) ? download_path : nil
  end

  def transparency_supports_domain_select_options(scope, id_column_name, title_column_name)
    scope.map{ |r| [r.send(title_column_name), r.send(id_column_name)] }
  end

  def transparency_export_worksheet_formats
    Transparency::Export.worksheet_formats.keys.map do |format_key|
      [ I18n.t("transparency_export.worksheet_formats.#{format_key}"), format_key ]
    end
  end

  def notice_in_exception_list?
    controller.try(:notice_exception?)
  end

  def categories_all_description
    OpenData::VcgeCategory.order(:title).map{|category| [category.title, category.id]}
  end
end
