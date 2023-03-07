module Admin::Integrations::Results::StrategicIndicators::Breadcrumbs
  include Admin::Integrations::Breadcrumbs

  protected

  def index_breadcrumbs
    [
      [t('admin.home.index.title'), admin_root_path],
      [t('admin.integrations.index.title'), admin_integrations_root_path],
      [t('admin.integrations.results.index.title'), admin_integrations_results_root_path],
      [t('.title'), '']
    ]
  end

  def show_edit_update_breadcrumbs
    integrations_index_breadcrumbs +
    [
      [t('admin.integrations.results.index.title'), admin_integrations_results_root_path],
      [t('admin.integrations.results.strategic_indicators.index.title'), admin_integrations_results_strategic_indicators_path],
      [strategic_indicator.title, '']
    ]
  end
end

