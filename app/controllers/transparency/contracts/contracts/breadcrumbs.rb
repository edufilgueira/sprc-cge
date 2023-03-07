module Transparency::Contracts::Contracts::Breadcrumbs

  protected

  def index_breadcrumbs
    [
      [t('transparency.home.index.title'), transparency_root_path],
      [t("shared.transparency.contracts.contracts.index.title"), '']
    ]
  end

  def show_edit_update_breadcrumbs
    [
      [t('transparency.home.index.title'), transparency_root_path],
      [t("shared.transparency.contracts.contracts.index.title"), transparency_contracts_contracts_path],
      [contract.title, '']
    ]
  end
end

