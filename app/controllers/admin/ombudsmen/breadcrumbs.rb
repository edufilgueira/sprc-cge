module Admin::Ombudsmen::Breadcrumbs

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
      [t('admin.ombudsmen.index.title'), admin_ombudsmen_path],
      [t('.title'), '']
    ]
  end

  def show_edit_update_breadcrumbs
    [
      [t('admin.home.index.title'), admin_root_path],
      [t('admin.ombudsmen.index.title'), admin_ombudsmen_path],
      [ombudsman.title, '']
    ]
  end
end
