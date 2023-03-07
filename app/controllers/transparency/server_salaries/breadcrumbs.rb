module Transparency::ServerSalaries::Breadcrumbs

  protected

  def index_breadcrumbs
    [
      [t('transparency.home.index.title'), transparency_root_path],
      [t('shared.transparency.server_salaries.index.title'), '']
    ]
  end

  def show_edit_update_breadcrumbs
    [
      [t('transparency.home.index.title'), transparency_root_path],
      [t('shared.transparency.server_salaries.index.title'), transparency_server_salaries_path],
      [server_salary.title, '']
    ]
  end
end
