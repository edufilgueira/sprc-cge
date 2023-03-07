module Admin::Integrations::Constructions::Ders::Breadcrumbs
  include Admin::Integrations::Breadcrumbs

  def index_breadcrumbs
    [
      [t('admin.home.index.title'), admin_root_path],
      [t('admin.integrations.index.title'), admin_integrations_root_path],
      [t("shared.transparency.constructions.ders.index.title"), '']
    ]
  end

  def show_edit_update_breadcrumbs
    integrations_index_breadcrumbs +
    [
      [t("shared.transparency.constructions.ders.index.title"), admin_integrations_constructions_ders_path],
      [der.title, '']
    ]
  end
end
