class PPA::Revision::RegionThemesController < PPAController
  include ::AuthorizedController
  include PPA::Revision
  include PPA::Revision::ReviewProblemSituationStrategies::Breadcrumbs

  load_and_authorize_resource class: PPA::Revision::Review::RegionTheme

  helper_method :resource, :model_class, :region_param, :theme_param, :axis_param

  PERMITTED_PARAMS = [

    :id,

    problem_situations_attributes: [
      :problem_situation_id,
      :persist,
      :id
    ],
    new_problem_situations_attributes: [
      :theme_id,
      :region_id,
      :description,
      :city_id,
      :city,
      :id
    ],
    regional_strategies_attributes: [
      :strategy_id,
      :persist,
      :id
    ],
    new_regional_strategies_attributes: [
      :theme_id,
      :region_id,
      :description,
      :id
    ]
  ]


  def edit
    @theme = resource.theme
    @region = resource.region
    @axis = resource.theme.axis
    @strategic_result = resource.theme.objectives.where(region_id: @region.id).pluck(:name).first
    @problem_situations_list = situations
    @regional_strategies_list = regional_strategies
    @review_problem_situation_strategy_id = params[:review_problem_situation_strategy_id]
    @region_theme_id = params[:id]
  end

  def show
    @theme = resource.theme
    @region = resource.region
    render layout: false
  end

  private

  def redirect_after_save_with_success
    redirect_to_index
  end

  def redirect_to_index
    redirect_to ppa_revision_review_problem_situation_strategy_path(id: resource.problem_situation_strategy_id, plan_id: resource.problem_situation_strategy.plan_id)
  end

  def resource_name
    model_class.to_s
  end

  def resource_symbol
    'ppa_revision_review_region_theme'
  end

  def model_class
    PPA::Revision::Review::RegionTheme
  end

  def region_theme_param
    params[:region_theme_id]
  end

  def region_param
    resource.region_id
  end

  def theme_param
  end

  def axis_param
  end

  def situations
    resource.problem_situations
      .joins(problem_situation: :situation)
      .pluck('ppa_situations.description', 'ppa_revision_review_problem_situations.id', 'persist')
      .sort
  end

  def regional_strategies
    resource.regional_strategies
      .joins(:strategy)
      .pluck('ppa_strategies.name', 'ppa_revision_review_regional_strategies.id', 'persist')
      .sort
  end
end