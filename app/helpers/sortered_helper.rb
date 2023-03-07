#
# Helper usados para os controllers que possuem ordenação
#
module SorteredHelper

  def sortered_table_header(column, title, options={}, remote=false)
    sort_link_content = sort_link_content(column, title, options)

    path = url_for(controller: controller_path, action: :index, params: sort_params(column))

    link_options = remote ? { 'data-remote': 'true' } : {}

    link_to(sort_link_content, path, link_options)
  end

  def sortered_remote_table_header(column, title, options={})
    sortered_table_header(column, title, options, true)
  end

  def sortered_table_active_class(column)
    (sortered_table_active?(column) ? 'table-active' : '')
  end

  private

  def sortered_table_active?(column)
    (sort_column.to_s == column.to_s)
  end

  def sorted_class(column)
    # sort_column é definido no controller e já trata se há um parâmetro de sort
    # ou se o sort é padrão.\
    sorted = (sortered_table_active?(column) ? 'sorted' : '')
    "#{sorted} #{controller_sort_direction}"
  end

  def sort_icon(direction)
    content_tag(:i, '', class: "fa fa-sort-#{direction}")
  end

  def sort_link_content(column, title, options)
    return raw(title) unless sortered_table_active?(column)

    sorted_class = sorted_class(column)
    span_class = (options[:center] ? "text-center #{sorted_class}" : sorted_class)

    content_tag(:span, raw(title + sort_icon(controller_sort_direction)), class: span_class)
  end

  def sort_params(column)
    filtered_params = request.query_parameters.merge(params.to_h)
    # precisa inverter a ordem se for coluna corrente
    filtered_params = filtered_params.merge({ sort_column: column, sort_direction: inverted_sort_direction })
    filtered_params.delete(:id)
    filtered_params.delete(:action)
    filtered_params.delete(:controller)

    filtered_params
  end

  def controller_sort_column
    # nos tests temos problemas com controller.sort_column
    controller.respond_to?(:sort_column) ? controller.sort_column : sort_column
  end

  def controller_sort_direction
    # nos tests temos problemas com controller.sort_direction
    controller.respond_to?(:sort_direction) ? controller.sort_direction : sort_direction
  end

  def inverted_sort_direction
    controller_sort_direction.to_sym == :asc ? :desc : :asc
  end
end
