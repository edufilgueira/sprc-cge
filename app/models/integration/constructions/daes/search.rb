#
# Métodos e constantes de busca para Integration::Constructions::Daes::Search
#

module Integration::Constructions::Daes::Search
  extend ActiveSupport::Concern
  include Searchable

  # Consts

  SEARCH_INCLUDES = [

  ]

  # LOWER é mais rápido que ILIKE

  SEARCH_EXPRESSION = %q{
    (integration_constructions_daes.id_obra)::TEXT LIKE LOWER(:search) OR
    LOWER(integration_constructions_daes.codigo_obra) LIKE LOWER(:search) OR
    unaccent(LOWER(integration_constructions_daes.contratada)) LIKE unaccent(LOWER(:search)) OR
    unaccent(LOWER(integration_constructions_daes.municipio)) LIKE unaccent(LOWER(:search)) OR
    unaccent(LOWER(integration_constructions_daes.secretaria)) LIKE unaccent(LOWER(:search)) OR
    unaccent(LOWER(integration_constructions_daes.descricao)) LIKE unaccent(LOWER(:search)) OR
    LOWER(integration_constructions_daes.numero_sacc) LIKE LOWER(:search)
  }
end
