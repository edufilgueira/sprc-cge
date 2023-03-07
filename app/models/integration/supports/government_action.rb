#
# Tabela Execício
#
# Ação Governamental
#

class Integration::Supports::GovernmentAction < ApplicationDataRecord

  # Validations

  ## Presence

  validates :codigo_acao,
    :titulo,
    presence: true

  # Public

  ## Instance methods

  ### Helpers

  def title
    titulo
  end
end
