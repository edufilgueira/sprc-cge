class Stats::ServerSalary < ApplicationDataRecord

  # Validations

  ## Presence

  validates :month,
    :year,
    presence: true

  ## Uniqueness

  validates_uniqueness_of :month,
    scope: [:year]

  # Serializations

  serialize :data, Hash

  #
  # Estatística mais completa e atualizada
  #
  def self.last_stat
    self.sorted.last
  end

  def self.sorted
    order('year, month asc')
  end
end
