#
# Tabela Execício
#
# Tipo de Despesa
#

class Integration::Supports::ExpenseType < ApplicationDataRecord

  # Validations

  ## Presence

  validates :codigo,
    presence: true

  # Public

  ## Instance methods

  ### Helpers

  def title
    codigo
  end
end
