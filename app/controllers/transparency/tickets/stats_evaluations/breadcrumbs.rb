module Transparency::Tickets::StatsEvaluations::Breadcrumbs

  protected

  def index_breadcrumbs
    [
      [t('transparency.home.index.title'), transparency_root_path],
      [t('.title'), '']
    ]
  end
end
