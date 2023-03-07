module Transparency::Sic::Home::Breadcrumbs

  protected

  def index_breadcrumbs
    [
      [t('app.home'), root_path],
      [t('transparency.sic.home.index.title'), '']
    ]
  end
end
