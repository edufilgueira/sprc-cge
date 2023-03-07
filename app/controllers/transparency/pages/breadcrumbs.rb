module Transparency::Pages::Breadcrumbs

  protected

  def index_breadcrumbs
    [
      [t('app.home'), root_path],
      [t('transparency.home.index.title'), transparency_root_path],
      [t('.title'), '']
    ]
  end

  def show_edit_update_breadcrumbs
    [
      [t('app.home'), root_path],
      [t('transparency.home.index.title'), transparency_root_path],
      [page.title, '']
    ]
  end
end
