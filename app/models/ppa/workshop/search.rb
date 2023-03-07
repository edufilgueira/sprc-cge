module PPA
  module Workshop::Search
    extend ActiveSupport::Concern
    include Searchable

    # Consts

    SEARCH_INCLUDES = []

    SEARCH_EXPRESSION = %q{
      LOWER(ppa_workshops.name) LIKE LOWER(:search)
    }

  end
end
