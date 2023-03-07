class ServiceType < ApplicationRecord
  include ::Sortable
  include ::Disableable
  include ::ServiceType::Search

  # Associations

  belongs_to :organ
  belongs_to :subnet


  # Delegations

  delegate :name, :title, :acronym, :full_title, to: :organ, prefix: true, allow_nil: true
  delegate :name, :acronym, :full_acronym, to: :subnet, prefix: true, allow_nil: true

  before_validation :set_organ


  # Validations

  ## Presence

  validates :name,
    :code,
    presence: true


  # Public

  ## Class methods

  def self.default_sort_column
    'service_types.name'
  end

  def self.other_organs
    find_by(other_organs: true)
  end

  def self.not_other_organs
    where.not(other_organs: true)
  end

  def self.only_no_characteristic
    no_characteristic = I18n.t('service_type.no_characteristic')
    where("service_types.name = ? and organ_id is null", no_characteristic).first
  end

  def self.without_no_characteristic
    no_characteristic = I18n.t('service_type.no_characteristic')
    where.not("service_types.name = ? and organ_id is null", no_characteristic)
  end

  ### Helpers

  def title
    if subnet.present?
      "[#{subnet_acronym}] - #{name}"
    elsif organ.present?
      "[#{organ_acronym}] - #{name}"
    else
      name
    end
  end


  # Private

  private

  def set_organ
    return unless subnet.present?

    self.organ_id = subnet.organ_id
  end
end
