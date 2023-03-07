#
# Helper usados para os controllers que possuem filtros
#
module FilteredHelper
  FILTERED_BASE = [:search, :search_datalist, :search_sacc]

  # Retorna se qualquer um dos filtros (FILTERED_COLUMNS, FILTERED_ENUMS, ...)
  # exceto se estiver contido em FILTERED_IGNORE_IN_HIGHLIGHTS.

  def filtered?
    filtered_params?(filtered_items)
  end

  # Usado para highlight de index filtrado
  def filter_expression
    params.fetch(:search, '').strip.split(' ')
  end

  # Usado para highlight do filtro
  def filtered_highlighted(text)
    plain_text = I18n.transliterate(text.to_s)
    plain_expressions = filter_expression.map {|s| I18n.transliterate(s)}

    highlight(plain_text, plain_expressions)
  end

  private

  def filtered_params?(filtered_param_names)
    filtered_param_names.each do |param_name|
      ignored = filtered_ignore_in_highlights.include?(param_name)

      return true if params[param_name].present? && (! ignored)
    end

    false
  end

  def filtered_items
    filtered_base +
    filtered_columns +
    filtered_enums +
    filtered_associations +
    filtered_custom +
    filtered_date_range
  end

  def filtered_base
    FILTERED_BASE
  end

  def filtered_enums
    controller_class::FILTERED_ENUMS
  end

  def filtered_columns
    controller_class::FILTERED_COLUMNS
  end

  def filtered_custom
    controller_class::FILTERED_CUSTOM
  end

  def filtered_date_range
    controller_class::FILTERED_DATE_RANGE
  end

  def filtered_ignore_in_highlights
    controller_class::FILTERED_IGNORE_IN_HIGHLIGHTS
  end

  def filtered_associations
    # as associações filtradas podem ser:
    #
    # 1) symbol indicando a relação (:city_id, por exemplo);
    # 2) hash indicando a relação indireta ({ memberships: :city_id }, por exemplo);
    #
    # este método deve garantir que existe valor em params[:nome_da_associação]

    controller_class::FILTERED_ASSOCIATIONS.map do |association|
      if (association.is_a? Hash)
        # valor do hash, para {memberships: :city_id}, retorna :city_id
        association.to_a[0][1]
      else
        association
      end
    end
  end

  def controller_class
    controller.class
  end
end
