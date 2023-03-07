class Transparency::Export::IntegrationResultsThematicIndicatorPresenter < Transparency::Export::BasePresenter

  COLUMNS = [
    :axis_title,
    :theme_title,
    :resultado,
    :indicador,
    :unidade,
    :sigla_orgao,
    :orgao,
    :valores_realizados,
    :valores_programados
  ].freeze


  # privates

  private

  def self.spreadsheet_header_title(column)
    Integration::Results::ThematicIndicator.human_attribute_name(column)
  end

  def self.columns
    COLUMNS
  end

  def columns
    self.class.columns
  end
end
