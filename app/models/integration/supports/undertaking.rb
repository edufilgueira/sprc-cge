#
# Tabela de Empreendimentos
#

class Integration::Supports::Undertaking < ApplicationDataRecord

  # Validations

  ## Presence

  validates :descricao,
    presence: true

  # Public

  ## Instance methods

  ### Helpers

  def title
    descricao
  end
end
