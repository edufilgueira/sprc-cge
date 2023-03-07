module Transparency::Results::ThematicIndicators::Breadcrumbs

  protected

  def index_breadcrumbs
    [
      [t('transparency.home.index.title'), transparency_root_path],
      [t('transparency.results.thematic_indicators.index.title'), '']
    ]
  end

  def show_edit_update_breadcrumbs
    [
      [t('transparency.home.index.title'), transparency_root_path],
      [t('transparency.results.thematic_indicators.index.title'), transparency_results_thematic_indicators_path],
      [thematic_indicator.title, '']
    ]
  end
end
