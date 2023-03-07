#
# Representa os temas da classificação orçamentário do ticket
#
class Theme < ApplicationRecord
  include ::Sortable
  include ::Disableable
  include ::Theme::Search

  # Setup

  acts_as_paranoid

  # Validations

  ## Presence

  validates :name,
    :code,
    presence: true

  # Scopes

  def self.default_sort_column
    'themes.code'
  end

  # Instace methods

  ## Helpers

  def title
    name
  end
end
