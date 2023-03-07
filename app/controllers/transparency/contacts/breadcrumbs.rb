module Transparency::Contacts::Breadcrumbs

  protected

  def index_breadcrumbs
    [
      [t('app.home'), root_path],
      [t('transparency.contacts.index.title'), '']
    ]
  end
end
