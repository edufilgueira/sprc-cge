class PPA::Revision::ReviewProblemSituationStrategiesController < PPAController
  include ::AuthorizedController
  include PPA::Revision
  include	PPA::Revision::ReviewProblemSituationStrategies::Breadcrumbs

  load_and_authorize_resource class: PPA::Revision::Review::ProblemSituationStrategy

  PERMITTED_PARAMS = [
    :id,
    :plan_id,
    region_themes_attributes: [
      :region_id,
      :theme_id,

      problem_situations_attributes: [
        :problem_situation_id,
        :persist
      ],
      new_problem_situations_attributes: [
        :theme_id,
        :region_id,
        :description,
        :city_id,
        :city
      ],
      regional_strategies_attributes: [
        :strategy_id,
        :persist
      ],
      new_regional_strategies_attributes: [
        :theme_id,
        :region_id,
        :description
      ]
    ]
  ]

  helper_method :resource, :model_class, :region_param, :theme_param, :axis_param, :region_theme_param, :id

  #before_action :sanitize_params, only: [:create, :update]
  before_action :associate_user, only: [:create]
  before_action :has_any_review?, only: [:create]

  def new
    if has_any_review?
      redirect_to ppa_revision_review_problem_situation_strategy_path(plan_id: plan.id, id: review.id)
    else
      super
    end
  end


  def conclusion
  end


  # Consulta da Revisão precisa refatorar para funcionar junto com priorização
  # def themes_list
  #   axis = PPA::Axis.find(axis_param)
  #   region = PPA::Region.find(region_param)
  #   worked_themes = axis.themes.joins(region_themes: :problem_situation_strategy).where(
  #     ppa_revision_review_problem_situation_strategies: { user_id: current_user.id, plan_id: plan.id },
  #     ppa_revision_review_region_themes: { region_id: region.id }
  #   )

  #   @available_themes = axis.themes - worked_themes

  #   render layout: false
  # end

  # Fase de priorização

  def themes_list
    axis = PPA::Axis.find(axis_param)
    region = PPA::Region.find(region_param)
    worked_themes_id =  PPA::Revision::Prioritization::RegionTheme.joins(:prioritization)
      .where(ppa_revision_prioritizations: { user_id: current_user.id } ).pluck(:theme_id)

    worked_themes = PPA::Theme.where(id: worked_themes_id)
    @available_themes = axis.themes - worked_themes

    render layout: false
  end


  private

  def review
    my_first_review
  end

  def resource_params
    return nil if !params[resource_symbol].present?

    params.require(resource_symbol).permit(self.class::PERMITTED_PARAMS)
  end

  def resource_name
    model_class.to_s
  end

  def resource_symbol
    'ppa_revision_review_problem_situation_strategy'
  end

  def model_class
    PPA::Revision::Review::ProblemSituationStrategy
  end

  def associate_user
    resource.user = current_user
  end

  # def sanitize_params
  #   params[resource_symbol][:problem_situations_attributes] = custom_problem_situation_params
  # end

  # def custom_problem_situation_params
  #   params = []
  #   problem_situation_params_hash.each do |param|
  #     params << {
  #       situation_id: param[0],
  #       persist: param[1]
  #     }
  #   end
  #   params
  # end

  def problem_situation_params_hash
    params[resource_symbol][:ppa_revision_review_problem_situation].to_unsafe_h
  end

  def has_any_review?
    if my_first_review.present?
      resource = my_first_review
    end
  end

  def my_first_review
    resources.accessible_by(current_ability).find_by(plan_id: plan.id)
  end

  def region_param
    params[:region_id]
  end

  def theme_param
    params[:theme_id]
  end

  def axis_param
    params[:axis_id]
  end

  def region_theme_param
    params[:region_theme_id]
  end

  def id
    params[:id]
  end
end