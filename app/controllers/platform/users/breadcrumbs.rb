module Platform::Users::Breadcrumbs

  protected

  def show_edit_update_breadcrumbs
    [
      [t('app.home'), root_path],
      [t('platform.users.edit.breadcrumb_title'), '']
    ]
  end
end

