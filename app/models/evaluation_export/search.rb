#
# Métodos e constantes de busca para Attendance
#

module EvaluationExport::Search
  extend ActiveSupport::Concern
  include Searchable

  # LOWER é mais rápido que ILIKE

  SEARCH_EXPRESSION = %q{
    evaluation_exports.title LIKE :search
  }
end
