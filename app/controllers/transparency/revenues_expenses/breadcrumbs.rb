module Transparency::RevenuesExpenses::Breadcrumbs

  protected

  def index_breadcrumbs
    [
      [t('transparency.home.index.title'), transparency_root_path],
      [t('shared.transparency.revenues_expenses.index.title'), '']
    ]
  end
end
