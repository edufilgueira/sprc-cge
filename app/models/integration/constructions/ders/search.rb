#
# Métodos e constantes de busca para Integration::Constructions::Ders::Search
#

module Integration::Constructions::Ders::Search
  extend ActiveSupport::Concern
  include Searchable

  # Consts

  SEARCH_INCLUDES = [

  ]

  # LOWER é mais rápido que ILIKE

  SEARCH_EXPRESSION = %q{
    (integration_constructions_ders.id_obra)::TEXT LIKE LOWER(:search) OR
    unaccent(LOWER(integration_constructions_ders.construtora)) LIKE unaccent(LOWER(:search)) OR
    unaccent(LOWER(integration_constructions_ders.supervisora)) LIKE unaccent(LOWER(:search)) OR
    unaccent(LOWER(integration_constructions_ders.distrito)) LIKE unaccent(LOWER(:search)) OR
    unaccent(LOWER(integration_constructions_ders.programa)) LIKE unaccent(LOWER(:search)) OR
    unaccent(LOWER(integration_constructions_ders.servicos)) LIKE unaccent(LOWER(:search)) OR
    unaccent(LOWER(integration_constructions_ders.trecho)) LIKE unaccent(LOWER(:search)) OR
    LOWER(integration_constructions_ders.numero_contrato_sic) LIKE LOWER(:search) OR
    LOWER(integration_constructions_ders.numero_contrato_der) LIKE LOWER(:search)
  }
end
