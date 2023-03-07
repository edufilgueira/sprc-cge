#
# Tabela Execício
#
# Grupo de Natureza da Despesa
#

class Integration::Supports::ExpenseNatureGroup < ApplicationDataRecord

  # Validations

  ## Presence

  validates :codigo_grupo_natureza,
    :titulo,
    presence: true

  # Public

  ## Instance methods

  ### Helpers

  def title
    titulo
  end
end
