#
# Tabela Execício
#
# Programa de Governo
#

class Integration::Supports::GovernmentProgram < ApplicationDataRecord

  # Validations

  ## Presence

  validates :ano_inicio,
    :codigo_programa,
    :titulo,
    presence: true

  # Public

  ## Instance methods

  ### Helpers

  def title
    titulo
  end
end
