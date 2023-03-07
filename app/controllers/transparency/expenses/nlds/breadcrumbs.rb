module Transparency::Expenses::Nlds::Breadcrumbs

  protected

  def index_breadcrumbs
    [
      [t('transparency.home.index.title'), transparency_root_path],
      [t('transparency.expenses.nlds.index.title'), '']
    ]
  end

  def show_edit_update_breadcrumbs
    [
      [t('transparency.home.index.title'), transparency_root_path],
      [t('transparency.expenses.nlds.index.title'), transparency_expenses_nlds_path],
      [nld.title, '']
    ]
  end
end
