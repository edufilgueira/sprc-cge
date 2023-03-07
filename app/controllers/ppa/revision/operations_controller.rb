# Clase de operação interna de etapa de priorização
# Não consegui coloca-lo onde deveria PPA::Revision::Prioritizations::
# A Rota não cria o subdiretorio
# A ROta está travando no terceiro nivel de nested objects e esse seria o quarto
# ppa/revision/operations => ficou assim
# ppa/revision/prioritizations/operations => deveria ser assim

class PPA::Revision::OperationsController < PPAController
  include ::AuthorizedController
  include PPA::Revision

  helper_method :region, :theme, :axis, :regional_strategies, :problem_situations, :region_theme

  def new
    render layout: false
  end


  private

  def region
    @region ||= PPA::Region.find(region_param)
  end

  def theme
    @theme ||= PPA::Theme.find(theme_param)
  end

  def axis
    @axis ||= PPA::Axis.find(axis_param)
  end

  def region_theme
    @region_theme ||= new_region_theme
  end

  def new_region_theme
    PPA::Revision::Prioritization::RegionTheme.new(
      region_id: region.id,
      theme_id: theme.id
    )
  end

  def regional_strategies
    @regional_strategies ||= theme.strategies
      .joins(:objective)
      .where(ppa_objectives: { region_id: region.id })
      .select(:id, :name)
  end

  def problem_situations

    @situations = PPA::Situation
      .where( ppa_problem_situations: {
        axis_id: axis.id,
        theme_id: theme.id,
        region_id: region.id }
      )
      .joins(:problem_situations)
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
