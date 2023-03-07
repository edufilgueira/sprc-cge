module Transparency::Results::StrategicIndicators::Breadcrumbs

  protected

  def index_breadcrumbs
    [
      [t('transparency.home.index.title'), transparency_root_path],
      [t('transparency.results.strategic_indicators.index.title'), '']
    ]
  end

  def show_edit_update_breadcrumbs
    [
      [t('transparency.home.index.title'), transparency_root_path],
      [t('transparency.results.strategic_indicators.index.title'), transparency_results_strategic_indicators_path],
      [strategic_indicator.title, '']
    ]
  end
end
