module Transparency::MacroregionInvestiments::Breadcrumbs

  protected

  def index_breadcrumbs
    [
      [t('transparency.home.index.title'), transparency_root_path],
      [t("shared.transparency.macroregion_investiments.index.title"), '']
    ]
  end

  def show_edit_update_breadcrumbs
    [
      [t('transparency.home.index.title'), transparency_root_path],
      [t("shared.transparency.macroregion_investiments.index.title"), transparency_macroregion_investiments_path],
      [investiment.title, '']
    ]
  end
end

