#
# Tabela Execício
#
# Modalidade de Aplicação
#

class Integration::Supports::ApplicationModality < ApplicationDataRecord

  # Validations

  ## Presence

  validates :codigo_modalidade,
    :titulo,
    presence: true

  # Public

  ## Instance methods

  ### Helpers

  def title
    titulo
  end
end
