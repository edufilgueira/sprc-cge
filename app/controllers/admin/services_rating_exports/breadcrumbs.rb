module Admin::ServicesRatingExports::Breadcrumbs

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
      [t('admin.survey_answer_exports.index.title'), admin_services_rating_exports_path],
      [t('.title'), '']
    ]
  end

  def show_edit_update_breadcrumbs
    [
      [t('admin.home.index.title'), admin_root_path],
      [t('admin.survey_answer_exports.index.title'), admin_services_rating_exports_path],
      [services_rating_export.title, '']
    ]
  end

end
