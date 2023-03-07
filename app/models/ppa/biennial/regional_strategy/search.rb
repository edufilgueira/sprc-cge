module PPA
  module Biennial
    module RegionalStrategy::Search
      extend ActiveSupport::Concern
      include Searchable

      # Consts

      SEARCH_INCLUDES = []

      SEARCH_EXPRESSION = <<~SQL
        LOWER(ppa_strategies.name) LIKE LOWER(:search) OR
        LOWER(ppa_objectives.name) LIKE LOWER(:search)
      SQL

    end
  end
end
