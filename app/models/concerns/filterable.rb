#
# Módulo incluído por models que permitem filtros.
#
module Filterable
  extend ActiveSupport::Concern

  included do
    before_save :clear_empty_filters
  end

  def clear_empty_filters
    check_blank = Proc.new { |_, v| v.delete_if(&check_blank) if v.kind_of?(Hash);  v.blank? }
    self.filters.delete_if(&check_blank)
  end

end
