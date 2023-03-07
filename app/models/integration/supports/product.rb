#
# Tabela Execício
#
# Produto
#

class Integration::Supports::Product < ApplicationDataRecord

  # Validations

  ## Presence

  validates :codigo,
    :titulo,
    presence: true

  # Public

  ## Instance methods

  ### Helpers

  def title
    titulo
  end
end
