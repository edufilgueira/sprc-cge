#
# Tabela Execício
#
# Grupo Financeiro
#

class Integration::Supports::FinanceGroup < ApplicationDataRecord

  # Validations

  ## Presence

  validates :codigo_grupo_financeiro,
    :titulo,
    presence: true

  # Public

  ## Instance methods

  ### Helpers

  def title
    titulo
  end
end
