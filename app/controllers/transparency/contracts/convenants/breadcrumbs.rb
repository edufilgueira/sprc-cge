module Transparency::Contracts::Convenants::Breadcrumbs

  protected

  def index_breadcrumbs
    [
      [t('transparency.home.index.title'), transparency_root_path],
      [t("shared.transparency.contracts.convenants.index.title"), '']
    ]
  end

  def show_edit_update_breadcrumbs
    [
      [t('transparency.home.index.title'), transparency_root_path],
      [t("shared.transparency.contracts.convenants.index.title"), transparency_contracts_convenants_path],
      [convenant.title, '']
    ]
  end
end
