class Integration::Supports::Theme < ApplicationDataRecord
  include ::Integration::Supports::Theme::Search
  include ::Sortable

  # Validations

  validates :codigo_tema,
    :descricao_tema,
    presence: true


  # Public

  ## Class methods

  ### Scopes

  def self.default_sort_column
    'integration_supports_themes.codigo_tema'
  end

  def self.default_sort_direction
    :asc
  end


  ## Instance methods

  ### Helpers

  def title
    descricao_tema
  end
end
