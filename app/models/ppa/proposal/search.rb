module PPA
  module Proposal::Search
    extend ActiveSupport::Concern
    include Searchable

    # Consts

    SEARCH_INCLUDES = [
      :user
    ]

    SEARCH_EXPRESSION = <<~SQL
      LOWER(ppa_proposals.strategy) LIKE LOWER(:search) OR
      LOWER(users.name) LIKE LOWER(:search)
    SQL

  end
end
