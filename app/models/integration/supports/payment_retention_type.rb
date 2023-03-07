#
# Tabela Execício
#
# Tipo de Retenção de Pagamento
#

class Integration::Supports::PaymentRetentionType < ApplicationDataRecord

  # Validations

  ## Presence

  validates :codigo_retencao,
    :titulo,
    presence: true

  # Public

  ## Instance methods

  ### Helpers

  def title
    titulo
  end
end
