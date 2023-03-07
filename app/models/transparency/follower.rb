class Transparency::Follower < ApplicationDataRecord

  # Associations

  belongs_to :resourceable, polymorphic: true


  # Validations

  ## Presence
  validates :email,
    :resourceable,
    :transparency_link,
    presence: true

  ## Format
  validates_format_of :email, with: User::REGEX_EMAIL_FORMAT

  ## Uniqueness
  validates_uniqueness_of :email,
    scope: [:resourceable_id, :resourceable_type, :unsubscribed_at]


  # Class methods

  ## Scopes

  def self.actives(resource)
    where(resourceable_id: resource, resourceable_type: resource.model_name.name, unsubscribed_at: nil)
  end

  # Instance methods

  def active?
    unsubscribed_at.nil?
  end

  def mark_as_unsubscribed
    update(unsubscribed_at: DateTime.now)
  end
end
