module Transparency::Revenues::RegisteredRevenues::Breadcrumbs

  protected

  def index_breadcrumbs
    [
      [t('transparency.home.index.title'), transparency_root_path],
      [t('shared.transparency.revenues.registered_revenues.index.title'), '']
    ]
  end
end
