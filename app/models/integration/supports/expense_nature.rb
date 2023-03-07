#
# Tabela Execício
#
# Natureza da Despesa
#

class Integration::Supports::ExpenseNature < ApplicationDataRecord

  # Validations

  ## Presence

  validates :codigo_natureza_despesa,
    :titulo,
    presence: true

  # Public

  ## Instance methods

  ### Helpers

  def title
    titulo
  end
end
