class Integration::Supports::Creditor < ApplicationDataRecord
  include ::Integration::Supports::Creditor::Search
  include ::Sortable

  # Validations

  ## Presence

  validates :nome,
    :codigo,
    :cpf_cnpj,
    presence: true

  # Public

  ## Class methods

  ### Scopes

  def self.default_sort_column
    'integration_supports_creditors.nome'
  end

  def self.default_sort_direction
    :asc
  end

  #
  # Usado por controllers que possuem o filtro de Credor.
  #
  def self.creditors_name_column
    'integration_supports_creditors.nome'
  end

  ## Instance methods

  ### Helpers

  def title
    nome
  end
end
