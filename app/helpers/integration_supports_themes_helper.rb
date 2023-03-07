module IntegrationSupportsThemesHelper

  def supports_themes_for_select
    sorted_supports_themes.map { |theme| [theme.title, theme.id] }
  end

  def supports_themes_for_select_with_all_option
    supports_themes_for_select.insert(0, [I18n.t('theme.select.all'), ' '])
  end


  private

  def sorted_supports_themes
    Integration::Supports::Theme.order(:descricao_tema)
  end
end
