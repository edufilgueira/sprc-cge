#
# Métodos e constantes de busca para Integration::Purchases::Purchase
#

module Integration::Purchases::Purchase::Search
  extend ActiveSupport::Concern
  include Searchable

  # Consts

  # LOWER é mais rápido que ILIKE

  SEARCH_EXPRESSION = %q{
    LOWER(integration_purchases_purchases.numero_publicacao) LIKE LOWER(:search) OR
    LOWER(integration_purchases_purchases.descricao_item) LIKE LOWER(:search) OR
    LOWER(integration_purchases_purchases.codigo_item) LIKE LOWER(:search) OR
    LOWER(integration_purchases_purchases.nome_fornecedor) LIKE LOWER(:search) OR
    LOWER(integration_purchases_purchases.nome_resp_compra) LIKE LOWER(:search) OR
    LOWER(integration_purchases_purchases.natureza_aquisicao) LIKE LOWER(:search) OR
    LOWER(integration_purchases_purchases.nome_grupo) LIKE LOWER(:search)
  }
end
