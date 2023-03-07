#
# Tabela Execício
#
# Função
#

class Integration::Supports::Function < ApplicationDataRecord

  # Validations

  ## Presence

  validates :codigo_funcao,
    :titulo,
    presence: true

  # Public

  ## Instance methods

  ### Helpers

  def title
    titulo
  end
end
