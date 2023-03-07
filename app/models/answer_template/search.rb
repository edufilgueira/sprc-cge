module AnswerTemplate::Search
  extend ActiveSupport::Concern
  include Searchable

  # Consts

  SEARCH_EXPRESSION = %q{
    LOWER(answer_templates.name) LIKE LOWER(:search)
  }
end
