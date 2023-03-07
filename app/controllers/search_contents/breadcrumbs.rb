module SearchContents::Breadcrumbs

  protected

  def index_breadcrumbs
    [
      [t('home.index.title'), root_path],
      [t('.title'), '']
    ]
  end
end
