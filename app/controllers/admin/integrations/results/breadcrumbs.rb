module Admin::Integrations::Results::Breadcrumbs
  include Admin::Integrations::Breadcrumbs

  protected

  def index_breadcrumbs
    integrations_index_breadcrumbs +
    [
      [t('.title'), '']
    ]
  end
end
