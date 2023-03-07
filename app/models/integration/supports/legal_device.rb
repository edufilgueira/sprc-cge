#
# Tabela Execício
#
# Dispositivo Legal
#

class Integration::Supports::LegalDevice < ApplicationDataRecord

  # Validations

  ## Presence

  validates :codigo,
    :descricao,
    presence: true

  # Public

  ## Instance methods

  ### Helpers

  def title
    descricao
  end
end
