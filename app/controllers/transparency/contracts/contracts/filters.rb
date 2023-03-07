module Transparency::Contracts::Contracts::Filters
  include Transparency::CreditorsSelectController

  FILTERED_COLUMNS = [
    :tipo_objeto,
    :cod_gestora,
    :cod_concedente,
    :decricao_modalidade,
    :infringement_status,
    :descricao_situacao
  ]

  FILTERED_CUSTOM = [
    :status,
    :data_assinatura,
    :data_publicacao_portal
  ]

  def filtered_resources

    filtered = filtered(resource_klass, sorted_resources)

    # a busca pelo numero_sacc desconsidera os demais filtros e tem precedencia sobre credor!
    return search_by_sacc(filtered) if params[:search_sacc].present?

    # a busca pelo nome do credor no campo 'search_datalist' desconsidera os demais filtros
    return search_by_creditor_name(filtered) if params[:search_datalist].present?

    filtered = filtered_by_status(filtered, params[:status])
    filtered = filtered_by_date(filtered, :data_assinatura, params_data_assinatura)
    filtered = filtered_by_date(filtered, :data_publicacao_portal, params_data_publicacao_portal)
    filtered = filtered_by_date(filtered, :data_vigencia, params_data_vigencia)
    filtered = filtered_by_date(filtered, :data_termino_original, params_data_termino_original)
    filtered = filtered_by_date(filtered, :data_rescisao, params_data_rescisao)

    filtered
  end

  def search_by_sacc(filtered)
    return filtered.where(isn_sic: params[:search_sacc])
  end

  def filtered_by_status(scope, status)
    if status == 'concluido'
      scope.concluido
    elsif status == 'vigente'
      scope.vigente
    else
      scope
    end
  end

  def filtered_by_date(scope, date_column_name, date_value)
    if date_value.present?
      dates = date_value.split(' - ')

      if dates.length == 2 # período
        start_date = dates[0].to_date rescue nil
        end_date = dates[1].to_date rescue nil

        if start_date.present? && end_date.present?
          return scope.send("#{date_column_name}_in_range", start_date, end_date)
        end
      elsif dates.length == 1 # filtro por data
        date = dates[0].to_date rescue nil

        return scope.where(date_column_name => date) if date.present?
      end
    end

    scope
  end
end
