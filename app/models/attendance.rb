class Attendance < ApplicationRecord
  include Attendance::Search
  include ::Sortable
  # Setup

  acts_as_paranoid

  # Enums

  enum service_type: [
    :sou_forward,
    :sic_forward,
    :sic_completed,
    :sou_search,
    :sic_search,
    :prank_call,
    :immediate_hang_up,
    :hang_up,
    :missing_data,
    :no_communication,
    :noise,
    :technical_problems,
    :incorrect_click,
    :transferred_call,
    :no_characteristic,
  ]

  # Associations

  belongs_to :ticket, inverse_of: :attendance
  belongs_to :created_by, class_name: 'User'
  belongs_to :updated_by, class_name: 'User'
  has_many :occurrences, dependent: :destroy
  has_many :attendance_organ_subnets, dependent: :destroy
  has_one :organ, through: :ticket

  #  Nested

  accepts_nested_attributes_for :ticket, reject_if: :reject_ticket?
  accepts_nested_attributes_for :attendance_organ_subnets, allow_destroy: true
  validates :attendance_organ_subnets, uniq_nested_attributes: { attribute: :organ_id }

  # Validations

  ## Presence

  validates :description,
    presence: true,
    unless: -> { reject_ticket? }

  validates :service_type,
    presence: true

  validates :answer,
    if: :completed?,
    presence: true

  validates :attendance_organ_subnets,
    presence: true,
    unless: -> { unknown_organ? || reject_ticket? || denunciation? }

  # Callbacks

  before_validation :set_unknown_organ_false,
    :set_unknown_subnet,
    if: :sic_completed?

  # Public

  ## Class methods

  ### Scopes

  def self.default_sort_column
    'attendances.protocol'
  end

  def self.default_sort_direction
    :desc
  end

  ## Instance methods

  ### Helpers

  def reject_ticket?
    ! (sou? || sic?)
  end

  def sou?
    sou_forward? || no_characteristic?
  end

  def sic?
    sic_forward? || sic_completed?
  end

  def completed?
    sic_completed? || no_characteristic?
  end

  def denunciation?
    ticket&.denunciation?
  end

  def service_type_str
    Attendance.human_attribute_name("service_type.#{service_type}")
  end

  def confirmed?
    return true unless ticket.present?

    ticket.internal_status.present? && !ticket.waiting_confirmation?
  end

  # Private

  private

  def set_unknown_subnet
    attendance_organ_subnets.each { |a| a.unknown_subnet = true }
  end

  def set_unknown_organ_false
    self.unknown_organ = false
  end
end
