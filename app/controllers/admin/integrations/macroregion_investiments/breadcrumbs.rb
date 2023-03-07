module Admin::Integrations::MacroregionInvestiments::Breadcrumbs
  include Admin::Integrations::Breadcrumbs

  protected

  def index_breadcrumbs
    [
      [t('admin.home.index.title'), admin_root_path],
      [t('admin.integrations.index.title'), admin_integrations_root_path],
      [t("shared.transparency.macroregion_investiments.index.title"), '']
    ]
  end

  def show_edit_update_breadcrumbs
    integrations_index_breadcrumbs +
    [
      [t("shared.transparency.macroregion_investiments.index.title"), admin_integrations_macroregion_investiments_path],
      [investiment.title, '']
    ]
  end
end
