#
# Tabela Execício
#
# Categoria Econômica
#

class Integration::Supports::EconomicCategory < ApplicationDataRecord

  # Validations

  ## Presence

  validates :codigo_categoria_economica,
    :titulo,
    presence: true

  # Public

  ## Instance methods

  ### Helpers

  def title
    titulo
  end
end
