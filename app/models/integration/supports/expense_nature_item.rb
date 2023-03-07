#
# Tabela Execício
#
# Item de Natureza da Despesa
#

class Integration::Supports::ExpenseNatureItem < ApplicationDataRecord

  # Validations

  ## Presence

  validates :codigo_item_natureza,
    :titulo,
    presence: true

  # Public

  ## Instance methods

  ### Helpers

  def title
    titulo
  end
end
