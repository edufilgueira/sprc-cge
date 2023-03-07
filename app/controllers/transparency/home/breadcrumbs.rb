module Transparency::Home::Breadcrumbs

  protected

  def index_breadcrumbs
    [
      [t('app.home'), root_path],
      [t('transparency.home.index.title'), '']
    ]
  end
end
