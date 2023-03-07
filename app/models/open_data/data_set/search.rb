#
# Métodos e constantes de busca para OpenData::DataSet
#

module OpenData::DataSet::Search
  extend ActiveSupport::Concern
  include Searchable

  # Consts

  SEARCH_EXPRESSION = %q{
    LOWER(open_data_data_sets.title) LIKE LOWER(:search) OR
    LOWER(open_data_data_sets.description) LIKE LOWER(:search) OR
    LOWER(integration_supports_organs.sigla) LIKE LOWER(:search) OR
    LOWER(integration_supports_organs.descricao_orgao) LIKE LOWER(:search)
  }

  included do
    def self.search_scope
      includes(:organ).references(:organ)
    end
  end
end
