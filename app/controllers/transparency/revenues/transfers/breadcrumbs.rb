module Transparency::Revenues::Transfers::Breadcrumbs

  protected

  def index_breadcrumbs
    [
      [t('transparency.home.index.title'), transparency_root_path],
      [t('shared.transparency.revenues.transfers.index.title'), '']
    ]
  end
end
