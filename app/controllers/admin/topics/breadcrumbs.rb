module Admin::Topics::Breadcrumbs

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
      [t('admin.topics.index.title'), admin_topics_path],
      [t('.title'), '']
    ]
  end

  def show_edit_update_breadcrumbs
    [
      [t('admin.home.index.title'), admin_root_path],
      [t('admin.topics.index.title'), admin_topics_path],
      [topic.title, '']
    ]
  end

  def delete_destroy_breadcrumbs
    [
      [t('admin.home.index.title'), admin_root_path],
      [t('admin.topics.index.title'), admin_topics_path],
      [t('.title'), '']
    ]
  end
end
