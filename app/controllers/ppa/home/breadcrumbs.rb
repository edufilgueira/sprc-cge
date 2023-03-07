module PPA::Home::Breadcrumbs

  protected

  def show_edit_update_breadcrumbs
    [
      [t('app.home'), root_path],
      [t('ppa.home.headline.title'), '']
    ]
  end
end
