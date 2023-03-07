module ServicesRating::Breadcrumbs

  protected

  def index_breadcrumbs
    [
      [t('app.home'), root_path],
      [t('.title'), '']
    ]
  end
end
