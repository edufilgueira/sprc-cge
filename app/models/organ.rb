#
# Representa a superclasse de órgão que pode ser STI de
#
# Órgão do Poder executivo (ExecutiveOrgan) e Órgão da Rede Ouvir (RedeOuvirOrgan)
#
class Organ < ApplicationRecord
  include ::Sortable
  include ::Organ::Search
  include ::Disableable

  # Setup

  acts_as_paranoid


  # Associations

  has_many :tickets
  has_many :attendance_evaluations, through: :tickets
  has_many :departments
  has_many :subnets
  has_many :subnet_departments, through: :subnets, source: :departments, class_name: :Department
  has_many :organ_associations, dependent: :destroy, inverse_of: :organ


  # nesteds

  accepts_nested_attributes_for :organ_associations, allow_destroy: true
  validates :organ_associations, uniq_nested_attributes: { attribute: :organ_association_id }

  # Class methods

  SECURITY_ORGANS = [
    'CGD',
    'PMCE',
    'SSPDS',
    'CBMCE',
    'PC',
    'PEFOCE',
    'AESP/CE',
    'SAP',
    'SUPESP',
    'CM'
  ]


  ## Scopes

  def self.default_sort_column
    'organs.acronym'
  end

  def self.organ_coordination
      where(id: [17, 107]).pluck(:acronym)
  end

  def self.couvi
    find_by_acronym('COUVI')
  end

  # Instance methods

  ## Helpers

  def title
    acronym
  end

  def full_title
    "#{acronym} - #{name}"
  end

  def full_acronym
    acronym
  end

  def average_attendance_evaluation(ticket_type = nil)
    if ticket_type.nil?
      attendance_evaluations.average(:average).to_f.round(1)
    else
      attendance_evaluations.where(tickets: { ticket_type: ticket_type }).average(:average).to_f.round(1)
    end
  end

  def executive_organ?
    is_a?(ExecutiveOrgan)
  end

  def rede_ouvir_organ?
    is_a?(RedeOuvirOrgan)
  end
end
