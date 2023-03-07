module Registrations::Breadcrumbs

  protected

  def new_create_breadcrumbs
    [
      [t('home.index.breadcrumb_title'), root_path],
      [t('.title'), '']
    ]
  end
end
