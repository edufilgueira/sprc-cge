#
# Métodos e constantes de busca para Event
#

module GasVoucher::Search
  extend ActiveSupport::Concern
  include Searchable

  # Consts

  # LOWER é mais rápido que ILIKE

  SEARCH_EXPRESSION = %q{
    LOWER(gas_vauchers.cpf) LIKE LOWER(:search)
  }
end
