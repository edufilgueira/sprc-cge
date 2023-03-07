#
# Tabela Execício
#
# Fonte de Recurso Qualificada
#

class Integration::Supports::QualifiedResourceSource < ApplicationDataRecord

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
