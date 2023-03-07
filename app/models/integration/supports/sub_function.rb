#
# Tabela Execício
#
# SubFunção
#

class Integration::Supports::SubFunction < ApplicationDataRecord

  # Validations

  ## Presence

  validates :codigo_sub_funcao,
    :titulo,
    presence: true

  # Public

  ## Instance methods

  ### Helpers

  def title
    titulo
  end
end
