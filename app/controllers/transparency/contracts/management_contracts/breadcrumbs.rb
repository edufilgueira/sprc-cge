module Transparency::Contracts::ManagementContracts::Breadcrumbs

  protected

  def index_breadcrumbs
    [
      [t('transparency.home.index.title'), transparency_root_path],
      [t('shared.transparency.contracts.management_contracts.index.title'), '']
    ]
  end

  def show_edit_update_breadcrumbs
    [
      [t('transparency.home.index.title'), transparency_root_path],
      [t('shared.transparency.contracts.management_contracts.index.title'), transparency_contracts_management_contracts_path],
      [contract.title, '']
    ]
  end
end
