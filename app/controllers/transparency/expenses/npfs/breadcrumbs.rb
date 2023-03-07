module Transparency::Expenses::Npfs::Breadcrumbs

  protected

  def index_breadcrumbs
    [
      [t('transparency.home.index.title'), transparency_root_path],
      [t('transparency.expenses.npfs.index.title'), '']
    ]
  end

  def show_edit_update_breadcrumbs
    [
      [t('transparency.home.index.title'), transparency_root_path],
      [t('transparency.expenses.npfs.index.title'), transparency_expenses_npfs_path],
      [npf.title, '']
    ]
  end
end
