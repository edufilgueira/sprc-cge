class PPA::Revision::PrioritizationsController < PPAController
  include ::AuthorizedController
  include PPA::Revision

  load_and_authorize_resource class: PPA::Revision::Prioritization

  PERMITTED_PARAMS = [
    :id,
    :plan_id,

    region_themes_attributes: [
      :id,
      :region_id,
      :theme_id,

      regional_strategies_attributes: [
        :strategy_id,
        :priority
      ]
    ]
  ]

  helper_method :prioritization, :plan, :resource, :model_class,
                :region_param, :theme_param, :axis_param, :region_theme_param,
                :id, :revised_region_themes, :region_theme



  # Ao entrar na priorização das estratégias faz o create, caso não exista e redireciona para edição
  def create
    prioritization = model_class.find_or_create_by(plan_id: plan.id, user_id: current_user.id)

    redirect_to edit_ppa_revision_prioritization_path(plan_id: plan.id, id: prioritization.id)
  end

  # Não remove registros do model Prioritizations.
  # Remove apenas Regional Strategy
  def destroy
    region_theme.destroy if region_theme.present?

    redirect_to ppa_revision_prioritization_path(plan_id: plan.id, id: prioritization.id)
  end

  def conclusion; render file: 'ppa/revision/review_problem_situation_strategies/conclusion'; end

  def index
    prioritization = model_class.find_or_create_by(plan_id: plan.id, user_id: current_user.id)

    redirect_to edit_ppa_revision_prioritization_path(plan_id: plan.id, id: prioritization.id)
  end

  def prioritization
    resource
  end

  def resource_symbol
    'ppa_revision_prioritizations'
  end

  def model_class
    PPA::Revision::Prioritization
  end

  def resource_klass
    model_class
  end

  def revised_region_themes
    prioritization.region_themes.joins(:region, theme: :axis).includes(:region, theme: :axis).order(
      'ppa_regions.name',
      'ppa_axes.name',
      'ppa_themes.name'
    )
  end

  def region_theme
    return nil if region_theme_param.nil?

    @region_theme ||= region_theme_model.find(region_theme_param)
  end

  def region_theme_model
    PPA::Revision::Prioritization::RegionTheme
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

end
