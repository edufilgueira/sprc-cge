#
# Tabela Execício
#
# Fonte de Recurso
#

class Integration::Supports::ResourceSource < ApplicationDataRecord

  # Validations

  ## Presence

  validates :titulo,
    presence: true

  # Public

  ## Instance methods

  ### Helpers

  def title
    titulo
  end
end
