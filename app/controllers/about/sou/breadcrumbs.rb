module About::Sou::Breadcrumbs

  protected

  def index_breadcrumbs
    [
      [t('app.home'), root_path],
      [t('about.sou.index.title'), '']
    ]
  end
end
