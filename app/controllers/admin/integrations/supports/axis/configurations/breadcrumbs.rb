module Admin::Integrations::Supports::Axis::Configurations::Breadcrumbs
  include Admin::Integrations::Breadcrumbs

  protected

  def show_edit_update_breadcrumbs
    integrations_index_breadcrumbs +
    [
      [configuration.title, '']
    ]
  end
end
