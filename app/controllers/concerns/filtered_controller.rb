#
# Módulo incluído em controllers que permitem filtros por enum, associations e
# atributos básicos.
#
# Os controllers que incluem esse módulo devem definir as constantes
# FILTERED_ENUMS e FILTERED_ASSOCIATIONS.
#
module FilteredController
  extend ActiveSupport::Concern

  #
  # Usado para permitir que os registros sejam filtrados por algum coluna da
  # collection padrão (sorted_resources, filtered_resources, ...).
  #
  FILTERED_COLUMNS = []

  #
  # Usado para permitir que os registros sejam filtrados por um enum do model.
  # Os valores enums filtrados serão transformados automaticamente para seus
  # respectivos valores no banco de dados.
  # Ex: enum house: [:camara, :senado], o params[:house] = 'senado' irá retornar
  # os registros com valor <1> para <house>.
  #
  FILTERED_ENUMS = []

  #
  # Usado para permitir que os registros sejam filtradas por suas associações
  # (belongs_to).
  #
  # Cada elemento pode ser um symbol (:state_id, por exemplo) ou um hash para
  # associações indiretas ({ program_editions: :city_id }, por exemplo).
  #
  FILTERED_ASSOCIATIONS = []

  #
  # Usado para permitir que os registros sejam filtradas por intervalos.
  #
  # É esperado que cada elemento seja um hash valores :start e :end ou
  # uma string de intervalo separado por '-''
  # Ex: filtro de ticket.confirmed_at: {start:'01/01/2017' , end: '31/12/2017'}
  # Ex: filtro de ticket.confirmed_at: '01/01/2017 - 31/12/2017'
  #
  FILTERED_DATE_RANGE = []

  # Usado para filtros que não estão mapeados mas que devem ser considerados
  # para exibir o aviso de que os resultados estão filtrados.

  FILTERED_CUSTOM = []

  # Usado para filtros que devem ser aplicados mas que não devem exibir mensagem
  # de 'Resultados filtrados ...[limpar filtro]'. Isso ocorre em casos como
  # o filtro 'exercicio' em ferramentas como diárias, em que o parâmetro de
  # filtro é obrigatório.

  FILTERED_IGNORE_IN_HIGHLIGHTS = []

  # Helper methods

  included do

    # Esse concern é usado por classes que não são controllers, como os models
    # de exportação. Por isso, temos que checar se o helper_method está
    # disponível!

    if respond_to?(:helper_method)
      helper_method [
        :filtered_count,
        :total_count
      ]
    end
  end

  def filtered_count
    @filtered_count ||= filtered_resources.count
  end

  def total_count
    @total_count ||= filtered_scope.count
  end

  # Public

  def filtered_resources
    @filtered_resources ||= filtered(resource_klass, filtered_scope)
  end

  #
  # Aplica o filtro básico (busca textual), por enums e associações
  #
  def filtered(model, resources)
    filtered_by_columns_enums_and_associations(
      model,
      resources.search(params[:search], nil, expression(model))
    )
  end

  # Private

  private

  def filtered_scope
    try(:sorted_resources) || resources
  end

  def filtered_columns
    self.class::FILTERED_COLUMNS
  end

  def filtered_enums
    self.class::FILTERED_ENUMS
  end

  def filtered_associations
    self.class::FILTERED_ASSOCIATIONS
  end

  def filtered_date_ranges
    self.class::FILTERED_DATE_RANGE
  end

  def search_expression(model)
    self.class.const_get(search_expression_name(model))
  end

  def search_expression_defined?(model)
    self.class.const_defined?(search_expression_name(model))
  end

  def search_expression_name(model)
    "#{model.to_s.upcase}_SEARCH_EXPRESSION"
  end

  def model_search_expression(model)
    model::SEARCH_EXPRESSION
  end

  def expression(model)
    search_expression_defined?(model) ? search_expression(model) : model_search_expression(model)
  end

  def filtered_by_columns(model, resources)
    filtered_by_value(model, resources, filtered_columns)
  end

  def filtered_by_enums(model, resources)
    filtered_by_value(model, resources, filtered_enums)
  end

  def filtered_by_associations(model, resources)
    filtered_by_value(model, resources, filtered_associations)
  end

  def filtered_by_date_ranges(model, resources)
    filtered_by_date_range_value(model, resources, filtered_date_ranges)
  end

  #
  # Helper que aplica os três filtros comuns
  #
  def filtered_by_columns_enums_and_associations(model, resources)
    filtered = filtered_by_date_ranges(model, resources)
    filtered = filtered_by_columns(model, filtered)
    filtered = filtered_by_enums(model, filtered)
    filtered_by_associations(model, filtered)
  end

  #
  # Método compartilhado pelo filtro por enums e pelo filtro de associações.
  # A única diferença entre eles é que o de enums exige que o valor a ser
  # filtrado no banco de dados seja traduzido do label do enum para o inteiro
  # que é armazenado.
  #
  def filtered_by_value(model, resources, filtered_columns_names)
    filtered = resources

    filtered_columns_names.each do |filter|
      table_name = table_name(model, filter)
      filter_name = filter_name(filter)
      filter_value = filter_value(model, filter)

      if (filter_value.present? || filter_value == false)

        if filter_value == '__is_null__' || filter_value == false
          filtered = filtered.where("#{table_name}": {"#{filter_name}": nil}).or(filtered.where("#{table_name}": {"#{filter_name}": false}))
        else
          filtered = filtered.where("#{table_name}": {"#{filter_name}": filter_value})
        end

      end
    end

    filtered
  end

  def filtered_by_date_range_value(model, resources, filtered_columns_names)
    filtered = resources

    filtered_columns_names.each do |filter|
      table_name = table_name(model, filter)
      filter_name = filter_name(filter)
      filter_range_value = filter_value(model, filter)

      if filter_range_value.present?
        range = date_range(filter_range_value)
        filtered = filtered.where("#{table_name}": {"#{filter_name}": range})
      end

    end

    filtered
  end

  def date_range(filter_range_value)
    start_date = date_value(filter_range_value, :start)
    end_date = date_value(filter_range_value, :end)
    [ DateTime.parse(start_date).beginning_of_day..DateTime.parse(end_date).end_of_day ]
  end

  def date_value(filter_range_value, position_key)
    return range_value_from_string(filter_range_value, position_key) unless filter_range_value.is_a?(Hash)
    return default_filter_range_value(position_key) if filter_range_value[position_key].blank?
    filter_range_value[position_key]
  end

  def range_value_from_string(filter_range_value, position_key)
    dates = filter_range_value.split('-')
    (position_key == :start) ? dates.first.strip : dates.second.strip
  end

  def default_filter_range_value(position_key)
    (position_key == :start) ? default_filter_range_start_value : default_filter_range_end_value
  end

  def default_filter_range_start_value
    I18n.l(Date.new(0))
  end

  def default_filter_range_end_value
    I18n.l(Date.today)
  end

  #
  # Retorna o nome da tabela usada no filtro de acordo com o model ou o filtro.
  #
  # Caso filter seja um hash, deve retornar a chave do hash. Isso indica que
  # se trata de um filtro de associação indireta e precisamos do nome da tabela
  # para filtrar.
  #
  # Caso contrário, a tabela é a do model passado como parâmtro.
  #
  def table_name(model, filter)
    if filter.is_a? Hash
      # retorna a chave do hash que indica a tabela de associação
      return filter.to_a[0][0]
    elsif filter.to_s.include?('.')
      return filter.split('.')[0]
    end
    model.table_name
  end

  #
  # Retorna o nome dd filtro de acordo com seu tipo.
  #
  # Caso filter seja um hash, deve retornar o valor do hash. Isso indica que
  # se trata de um filtro de associação indireta e precisamos do nome da coluna
  # para filtrar.
  #
  def filter_name(filter)
    if filter.is_a? Hash
      # retorna o valor do hash que indica a coluna na tabela associada
      return filter.to_a[0][1]
    elsif filter.to_s.include?('.')
      return filter.split('.')[1]
    end
    filter.to_s.downcase
  end

  #
  # Retorna o valor do parâmetro que deve ser filtrado.
  #
  # Caso filter seja de enum, o valor deve ser transformado pois o filtro
  # passado é o nome do enum ('camara', por exemplo) e o filtro no banco de dados deve ser
  # pelo valor do enum (0, por exemplo).
  #
  def filter_value(model, filter)
    table_name = table_name(model, filter)
    filter_name = filter_name(filter)

    param_value = params[filter_name]

    if param_value == nil
      # tenta achar parâmetro de outra tabela
      param_value = params["#{table_name}.#{filter_name}"]
    end

    # filtros do tipo 'não preenchido...'
    return param_value if param_value == '__is_null__'

    return enum_value(model, filter_name, param_value) if enum?(filter_name)
    return boolean_value(param_value) if boolean?(param_value)

    param_value
  end

  #
  # Retorna se o filtro é do tipo enum. É usado para poder transformar o valor
  # de enum quando necessário.
  #
  def enum?(filter_name)
    filtered_enums.include?(filter_name.to_sym)
  end

  #
  # Retorna se o filtro é do tipo boolean de acordo com seu valor, para não ser
  # necessário consultar os metadados da coluna. Os casos de uso não indicam
  # problemas pois os valores passados são 'true' ou 'false'
  #
  def boolean?(filter_value)
    filter_value == 'true' || filter_value == 'false'
  end

  #
  # Retorna o valor do filtro de no enum.
  # Ex: em Matter.house = [:camara, :senado], filter_enum_value(model, :house, 'senado')
  # deve retornar 1, que é o valor gravado no banco de dados.
  #
  def enum_value(model, filter_name, param_value)
    return nil unless param_value.present?

    model.send(filter_name.pluralize)[param_value]
  end

  #
  # Retorna o valor do filtro como booleano para ser passado para a query
  # Ex: 'true' -> true, 'false' -> false
  #
  def boolean_value(param_value)
    return true if param_value == 'true'
    return false if param_value == 'false'
    nil
  end
end
