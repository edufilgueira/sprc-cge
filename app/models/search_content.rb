#
# Representa um registro de busca
#

class SearchContent < ApplicationRecord
  include ::Sortable
  include ::Globalizeable
  include ::SearchContent::Search

  # Setup

  translates :title, :description, :content, fallbacks_for_empty_translations: false

  # Validations

  ## Presence

  validates :title,
    :content,
    :description,
    :link,
    presence: true

  # Scopes

  def self.default_sort_column
    'search_content_translations.title'
  end
end
