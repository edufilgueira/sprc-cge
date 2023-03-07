#
# Módulo incluído por models que usam a gem globalize
#
module Globalizeable
  extend ActiveSupport::Concern

  class_methods do

    def sorted(sort_column = nil, sort_direction = :asc)
      if sort_column.present?
        sorted_scope.order("#{sort_column} #{sort_direction}")
      else
        sorted_scope.order("#{default_sort_column} #{default_sort_direction}")
      end
    end

    private

    def sorted_scope
      joins(:translations).where("#{translation_table_name}.locale = '#{I18n.locale}'")
    end

    def translation_table_name
      translation_class.table_name
    end

  end

  def cache_key
    super + '-' + Globalize.locale.to_s
  end
end
