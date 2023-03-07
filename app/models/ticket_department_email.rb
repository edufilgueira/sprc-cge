class TicketDepartmentEmail < ApplicationRecord

  # Setup

  has_secure_token

  acts_as_messageable

  acts_as_paranoid

  #  Enums

  # Associations
  has_many :ticket_logs, as: :responsible, dependent: :destroy

  belongs_to :ticket_department
  belongs_to :answer, dependent: :destroy

  # Delegations

  delegate :description, to: :answer, prefix: true, allow_nil: true
  delegate :department, to: :ticket_department


  # Nested

  accepts_nested_attributes_for :answer

  # Attributes

  # Validations

  ## Presence

  validates :email,
    :ticket_department,
    presence: true

  ## Format

  validates_format_of :email, with: User::REGEX_EMAIL_FORMAT, allow_blank: true


  #  Callbacks

  # Public

  ## Instance methods

  def mailboxer_email(_object)
    email
  end

  ### Scopes

  ### Helpers

  def title
    email
  end

  # private

end
