class MobileApp < ApplicationRecord
  include ::Sortable
  include ::MobileApp::Search

  # Setup

  attachment :icon

  # Associations

  has_and_belongs_to_many :mobile_tags

  # Validations

  ## Presence

  validates :name,
    :icon,
    :mobile_tags,
    presence: true

  validates :name,
    uniqueness: true

  # Scopes

  def self.default_sort_column
    'mobile_apps.name'
  end

  def self.official
    where(official: true)
  end

  def self.unofficial
    where.not(official: true)
  end

  # Public

  ## Instance methods

  def url
    Refile.attachment_url(self, :icon)
  end

  ## Helpers

  def title
    name
  end
end
