module Transparency::CityUndertakings::Breadcrumbs

  protected

  def index_breadcrumbs
    [
      [t('transparency.home.index.title'), transparency_root_path],
      [t("shared.transparency.city_undertakings.index.title"), '']
    ]
  end

  def show_edit_update_breadcrumbs
    [
      [t('transparency.home.index.title'), transparency_root_path],
      [t("shared.transparency.city_undertakings.index.title"), transparency_city_undertakings_path],
      [city_undertaking.title, '']
    ]
  end
end

