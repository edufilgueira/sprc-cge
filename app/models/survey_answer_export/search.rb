#
# Métodos e constantes de busca para SurveyAnswerExport
#

module SurveyAnswerExport::Search
  extend ActiveSupport::Concern
  include Searchable

  # Consts

  # LOWER é mais rápido que ILIKE

  SEARCH_EXPRESSION = %q{
    LOWER(survey_answer_exports.name) LIKE LOWER(:search)
  }
end
