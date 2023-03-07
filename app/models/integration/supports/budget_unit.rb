#
# Tabela Execício
#
# Unidade Orçamentária
#

class Integration::Supports::BudgetUnit < ApplicationDataRecord

  # Associations

  belongs_to :management_unit,
    class_name: 'Integration::Supports::ManagementUnit',
    foreign_key: :codigo_unidade_gestora,
    primary_key: :codigo

  # Validations

  ## Presence

  validates :codigo_unidade_gestora,
    :codigo_unidade_orcamentaria,
    :titulo,
    presence: true

  # Public

  ## Class methods

  def self.from_executivo
    joins(:management_unit).where('integration_supports_management_units.poder': 'EXECUTIVO')
  end

  ## Instance methods

  ### Helpers

  def title
    titulo
  end
end
