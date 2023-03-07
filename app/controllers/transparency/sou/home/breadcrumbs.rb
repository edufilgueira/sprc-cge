module Transparency::Sou::Home::Breadcrumbs

  protected

  def index_breadcrumbs
    [
      [t('app.home'), root_path],
      [t('transparency.sou.home.index.title'), '']
    ]
  end
end
