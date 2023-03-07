#
# Métodos e constantes de busca para Integration::Purchases::Purchase
#

module Integration::Macroregions::MacroregionInvestiment::Search
  extend ActiveSupport::Concern
  include Searchable

  # Consts

  # LOWER é mais rápido que ILIKE

  SEARCH_EXPRESSION = %q{
    LOWER(integration_macroregions_macroregion_investiments.descricao_regiao) LIKE LOWER(:search)
  }
end
