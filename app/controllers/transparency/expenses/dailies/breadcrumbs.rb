module Transparency::Expenses::Dailies::Breadcrumbs

  protected

  def index_breadcrumbs
    [
      [t('transparency.home.index.title'), transparency_root_path],
      [t('transparency.expenses.dailies.index.title'), '']
    ]
  end

  def show_edit_update_breadcrumbs
    [
      [t('transparency.home.index.title'), transparency_root_path],
      [t('transparency.expenses.dailies.index.title'), transparency_expenses_dailies_path],
      [daily.title, '']
    ]
  end
end
