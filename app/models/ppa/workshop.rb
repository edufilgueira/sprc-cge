class PPA::Workshop < ApplicationRecord
  include PPA::Workshop::Search
  include ::Sortable

  # Associations

  belongs_to :plan, class_name: 'PPA::Plan'
  belongs_to :city, class_name: 'PPA::City'
  has_many :documents, as: :uploadable, dependent: :destroy
  has_many :photos, as: :uploadable, dependent: :destroy

  # Validations

  validates :name, :start_at, :end_at, :address, :link, presence: true
  validates :participants_count, numericality: { only_integer: true, greater_than: 0 }, allow_nil: true
  validates :city, presence: true
  validate :valid_date_range

  # Nested

  accepts_attachments_for :documents
  accepts_attachments_for :photos

  accepts_nested_attributes_for :documents, reject_if: :attachment_blank?, allow_destroy: true
  accepts_nested_attributes_for :photos, reject_if: :attachment_blank?, allow_destroy: true

  # delegations

  delegate :name, :region_name, to: :city, prefix: true, allow_nil: true
  delegate :name, to: :city, prefix: true, allow_nil: true
  #delegate :name, to: :region, prefix: true, allow_nil: true

  # Scopes

  def self.sorted(*)
    order(:start_at)
  end

  def self.starting_at(date=nil)
    date = date.blank? ? Date.today : Date.parse(date)
    where('start_at >= ?', date.beginning_of_day).sorted
  end

  def self.finished_until(date=nil)
    today  = Date.today.end_of_day
    parsed = (date.blank? ? Date.today : Date.parse(date)).end_of_day
    date   = parsed > today ? today : parsed

    where('end_at <= ?', date)
  end

  scope :in_city, ->(city_id) { where(city_id: city_id) }

  def self.default_sort_column
    'ppa_workshops.name'
  end

  def address_with_city
    [address, city_name].join(', ')
  end

  private

  def attachment_blank?
    attributes['attachment'] == '{}'
  end

  def valid_date_range
    return unless start_at && end_at

    errors.add(:end_at, :invalid_range) if end_at < start_at
  end
end
