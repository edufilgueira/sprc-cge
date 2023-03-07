module Transparency::Revenues::Accounts::Breadcrumbs

  protected

  def index_breadcrumbs
    [
      [t('transparency.home.index.title'), transparency_root_path],
      [t('shared.transparency.revenues.accounts.index.title'), '']
    ]
  end
end
