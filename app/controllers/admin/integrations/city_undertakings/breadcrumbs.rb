module Admin::Integrations::CityUndertakings::Breadcrumbs
  include Admin::Integrations::Breadcrumbs

  protected

  def index_breadcrumbs
    [
      [t('admin.home.index.title'), admin_root_path],
      [t('admin.integrations.index.title'), admin_integrations_root_path],
      [t("shared.transparency.city_undertakings.index.title"), '']
    ]
  end

  def show_edit_update_breadcrumbs
    integrations_index_breadcrumbs +
    [
      [t("shared.transparency.city_undertakings.index.title"), admin_integrations_city_undertakings_path],
      [city_undertaking.title, '']
    ]
  end
end
