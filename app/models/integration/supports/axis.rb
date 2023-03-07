class Integration::Supports::Axis < ApplicationDataRecord
  include ::Integration::Supports::Axis::Search
  include ::Sortable

  # Validations

  validates :codigo_eixo,
    :descricao_eixo,
    presence: true

  # Public

  ## Class methods

  ### Scopes

  def self.default_sort_column
    'integration_supports_axes.codigo_eixo'
  end

  def self.default_sort_direction
    :asc
  end


  ## Instance methods

  ### Helpers

  def title
    descricao_eixo
  end
end
