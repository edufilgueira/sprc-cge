module Transparency::RevenuesHelper

  def select_year_data_attribute
    { 'dependent-select': 'consolidado',
      'child-container': '[data-dependent-select-child=consolidado]',
      'param-name': 'year',
      'url': api_v1_integration_supports_revenue_natures_revenue_types_path(revenue_nature_type: 'consolidado'),
      'url-child': 'true'
    }
  end

  def select_month(type)
    select_tag(
      type,
      options_for_select(date_months_for_select,
        param_type_month(type)), #condicao ou so deve acionar no month_end
      data: {
        'filter-bar-bypass-clear': '',
        'stats-month': type.to_s.split('_').last
      },
      class: 'form-control w-100'
    )
  end

  def select_tag_secretaries_or_organs(field_name, type)
    select_tag(field_name,
      options_for_select(
        get_url_for_secretary_or_organ(type),
        params[field_name]
      )
    )
  end

  def get_url_for_secretary_or_organ(type)
    if type == :organ
      supports_organs_and_secretaries_from_executivo_for_select_with_all_option(false, :codigo_orgao)
    else
      supports_secretaries_from_executivo_for_select_with_all_option
    end
  end

  def revenues_humam_attributes(attribute)
    if attribute.in? [:secretary, :orgao]
      Integration::Revenues::Revenue.human_attribute_name(attribute)
    else
      Integration::Supports::RevenueNature.human_attribute_name(attribute)
    end
  end

  def tree_organizer_options
    {
      id: 'revenues',
      default_node_types: default_node_types,
      default_node_types_path: default_node_types_path,
      node_type_model: Integration::Supports::RevenueNature,
      node_types_options: node_types_options
    }
  end


  private

  def param_type_month(type)
    if type == :month_end
      params[:type] || last_stat_month
    else
      params[:type]
    end
  end

  def select_for_filter(type, field_name, genre = :female)
    select_tag(field_name,
      options_for_select([]),
      data: {
        'dependent-select-child': 'consolidado',
        'dependent-select-blank': I18n.t("messages.filters.select.all.#{genre}"),
        'url-child': api_v1_integration_supports_revenue_natures_revenue_types_path(revenue_nature_type: type)
      }
    )
  end

  def full_title_only_last_element(revenue_nature)
    revenue_nature.full_title.split('>').last
  end

  def integration_revenues_years
    Integration::Revenues::Revenue.distinct(:year).pluck(:year).sort
  end

  def view_consolidated(consolidado_data)    
    charts_tabs = [:secretary, :categoria_economica, :origem, :subfonte]
    return charts_tabs if !consolidado_data.present?
    charts_tabs + [:consolidado]    
  end
end
