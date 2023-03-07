# RESTful API pública de cidades por estado
#
# 1) INDEX
#    GET /api/v1/cities
#    HTTP 200 - [ { city }, { city }, ... ]
#
class Api::V1::PPAController < Api::V1::ApplicationController

  def themes_for_axis
  	object_response(themes)
  end

  # Retorna um único Resultado estratégico
  def strategic_result
    return nil if !param_theme_id.present? or !param_region_id.present?

    object_response(
      theme.objectives.where(region_id: param_region_id).pluck(:id, :name)
    )
  end

  def regional_strategies
    return nil if !param_theme_id.present? or !param_region_id.present?

    object_response(
      theme.strategies.joins(:objective).where(ppa_objectives: { region_id: param_region_id }).select(:id, :name)
    )
  end

  def theme_description
    return nil if !param_theme_id.present?
    render plain: PPA::Theme.find(param_theme_id).description
  end

  def link_report
    return nil if !param_theme_id.present? || !param_axis_id.present? || !param_region_id.present?
    url = 'http://appsweb.seplag.ce.gov.br/ppa/relatorio_iniciativas_entregas/execucaodiretrizes'
    render plain: url + "?eixo=#{axis.code}&tema=#{theme.isn}&regiao=#{region.isn}"
  end


  def problem_situations
    return nil if !param_theme_id.present? or !param_region_id.present? or !param_axis_id.present?
    object_response(situations)
  end

  def cities_for_region
    return nil if !param_region_id.present?

    object_response(cities_filtered_region)
  end

  def has_theme_report
    has = (theme.try(:code).try(:present?) and !(theme.code.in? theme.class.no_report_activities)).to_s
    render plain: has
  end

  private

  def situations
    PPA::Situation
      .where( ppa_problem_situations: {
        axis_id: axis.id,
        theme_id: theme.id,
        region_id: region.id }
      )
      .joins(:problem_situations)
      .pluck(:description, 'ppa_problem_situations.id')
      .sort
  end

  def themes
  	PPA::Theme.where(axis_id: param_axis_id).order(:name)
  end

  def param_axis_id
  	params[:axis_id]
  end

  def param_theme_id
    params[:theme_id]
  end

  def param_region_id
    params[:region_id]
  end

  def theme
    PPA::Theme.find(param_theme_id)
  end

  def axis
    PPA::Axis.find(param_axis_id)
  end

  def region
    PPA::Region.find(param_region_id)
  end

  def cities_filtered_region
    PPA::City.where(ppa_region_id: param_region_id)
  end

  

end
