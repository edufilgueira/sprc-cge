module Admin::MobileApps::Breadcrumbs
  include ::MobileApps::BaseBreadcrumbs

  protected

  def new_create_breadcrumbs
    [
      bradcrumb_home,
      bradcrumb_index,
      [t('.title'), '']
    ]
  end

  def show_edit_update_breadcrumbs
    [
      bradcrumb_home,
      bradcrumb_index,
      [mobile_app.title, '']
    ]
  end

  private

  def bradcrumb_index
    [t('admin.mobile_apps.index.title'), admin_mobile_apps_path]
  end
end
