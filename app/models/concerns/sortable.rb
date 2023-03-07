##
# Módulo incluído por models que permitem ordenação em cruds padrão.
##
module Sortable
  extend ActiveSupport::Concern

  class_methods do

    def sorted(sort_column = nil, sort_direction = :asc)
      if sort_column.present?
        order("#{sort_column} #{sort_direction}")
      else
        order("#{default_sort_column} #{default_sort_direction}")
      end
    end

    def default_sort_column
      # Deve ser implementado por quem inclue o módulo
    end

    # Ordenação padrão é ascendente.

    def default_sort_direction
      :asc
    end
  end
end
