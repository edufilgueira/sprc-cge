module Admin::Pages::Breadcrumbs

  protected

  def index_breadcrumbs
    [
      [t('admin.home.index.title'), admin_root_path],
      [t('.title'), '']
    ]
  end

  def new_create_breadcrumbs
    [
      [t('admin.home.index.title'), admin_root_path],
      [t('admin.pages.index.title'), admin_pages_path],
      [t('.title'), '']
    ]
  end

  def show_edit_update_breadcrumbs
    [
      [t('admin.home.index.title'), admin_root_path],
      [t('admin.pages.index.title'), admin_pages_path],
      [page.title, '']
    ]
  end
end
