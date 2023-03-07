#
# Tabela Execício
#
# Elemento de Despesa
#

class Integration::Supports::ExpenseElement < ApplicationDataRecord

  # Validations

  ## Presence

  validates :codigo_elemento_despesa,
    :titulo,
    presence: true

  # Public

  ## Instance methods

  ### Helpers

  def title
    titulo
  end
end
