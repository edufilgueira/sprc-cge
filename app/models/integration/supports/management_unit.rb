#
# Tabela Execício
#
# Unidade Gestora
#

class Integration::Supports::ManagementUnit < ApplicationDataRecord

  # Validations

  ## Presence

  validates :cnpj,
    :codigo,
    :poder,
    :sigla,
    :tipo_administracao,
    :tipo_de_ug,
    :titulo,
    presence: true

  # Public

  ## Class methods

  def self.from_executivo
    where(poder: 'EXECUTIVO')
  end

  ## Instance methods

  ### Helpers

  def title
    titulo
  end

  def acronym
    sigla
  end
end
