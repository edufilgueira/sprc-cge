class AnswerTemplate < ApplicationRecord
  include ::Sortable
  include AnswerTemplate::Search

  # Associations

  belongs_to :user


  # Validations

  ## Presence

  validates :user,
    :name,
    :content,
    presence: true

  # Helpers

  def title
    name
  end

  # Scopes methods

  def self.default_sort_column
    'answer_templates.name'
  end
end
