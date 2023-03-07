class Ombudsman < ApplicationRecord
  include ::Sortable
  include ::Ombudsman::Search

  enum kind: [:executive, :sesa]

  validates :title,
            :phone,
            :kind,
            presence: true


  # Class methods

  ## Scopes

  def self.from_kind(kind)
    where(kind: kind)
  end

  def self.default_sort_column
    'ombudsmen.title'
  end
end
