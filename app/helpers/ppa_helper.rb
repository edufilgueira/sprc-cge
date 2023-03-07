module PPAHelper

  def themes_for_select
    themes.order(:name).pluck(:name, :id)
  end

	def axes_for_select(plan_id)
    axes(plan_id).pluck(:name, :id)
  end

  def regions
    PPA::Region.all
  end

  def axes(plan_id)
  	PPA::Axis.where(plan_id: plan_id)
  end

  def themes
  	PPA::Theme.all
  end

  def problem_situation_strategy_regions(problem_situation_strategy)
    problem_situation_strategy.region_themes.joins(:region).select('ppa_regions.id', 'ppa_regions.name').distinct
  end

  def problem_situation_strategy_axes_by_region(problem_situation_strategy, region_id)
    problem_situation_strategy.region_themes.joins(theme: :axis).where(
      ppa_revision_review_region_themes: { region_id: region_id }
    ).select('ppa_axes.id, ppa_axes.name').distinct
  end

  def problem_situation_strategy_themes(problem_situation_strategy, region_id, axis_id)
    problem_situation_strategy.region_themes.joins(theme: :axis).where(
      ppa_revision_review_region_themes: { region_id: region_id },
      ppa_axes: { id: axis_id }
    ).select('ppa_revision_review_region_themes.id, ppa_themes.name').distinct
  end

  def last_region_theme_worked(problem_situation_strategy)
    problem_situation_strategy.region_themes.order(updated_at: :desc).try(:first)
  end

  def cities_by_region(region_id)
    PPA::City.where(ppa_region_id: region_id)
  end
end
