#
# Módulo incluído em controllers que permitem ordenação.
#
# Os controllers que incluem esse módulo podem sobrescrever as contantes:
#
# SORT_COLUMNS (default: [])
#
module SortedController
  extend ActiveSupport::Concern

  SORT_COLUMNS = []

  included do
    helper_method [
      :sort_column,
      :sort_columns
    ]
  end

  # Helper methods

  def sort_columns
    self.class::SORT_COLUMNS
  end

  def sort_column
    @sort_column ||= (params_sort_column || default_sort_column)
  end

  def sort_direction
    @sort_direction ||= (params_sort_direction || default_sort_direction)
  end

  def sorted_resources
    default_sort_scope.sorted(sort_column, sort_direction)
  end

  # Private

  private

  def params_sort_column
    params[:sort_column].present? && params[:sort_column]
  end

  def params_sort_direction
    params[:sort_direction].present? && params[:sort_direction]
  end

  def default_sort_column
    # Responde com a definição do model, caso exista.
    resource_klass.try(:default_sort_column)
  end

  def default_sort_direction
    # Responde com a definição do model, caso exista.
    resource_klass.try(:default_sort_direction)
  end

  def default_sort_scope
    # Responde com o search escope caso a classe possua esse método.
    # Responde com resource_klass.all, caso contrário.

    resource_klass.respond_to?(:search_scope) ? resource_klass.search_scope : resource_klass.all
  end
end
