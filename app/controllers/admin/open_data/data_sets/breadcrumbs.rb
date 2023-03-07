module Admin::OpenData::DataSets::Breadcrumbs

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
      [t('admin.open_data.data_sets.index.title'), admin_open_data_data_sets_path],
      [t('.title'), '']
    ]
  end

  def show_edit_update_breadcrumbs
    [
      [t('admin.home.index.title'), admin_root_path],
      [t('admin.open_data.data_sets.index.title'), admin_open_data_data_sets_path],
      [data_set.title, '']
    ]
  end
end
