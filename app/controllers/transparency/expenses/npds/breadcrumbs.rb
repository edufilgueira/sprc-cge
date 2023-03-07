module Transparency::Expenses::Npds::Breadcrumbs

  protected

  def index_breadcrumbs
    [
      [t('transparency.home.index.title'), transparency_root_path],
      [t('transparency.expenses.npds.index.title'), '']
    ]
  end

  def show_edit_update_breadcrumbs
    [
      [t('transparency.home.index.title'), transparency_root_path],
      [t('transparency.expenses.npds.index.title'), transparency_expenses_npds_path],
      [npd.title, '']
    ]
  end
end
