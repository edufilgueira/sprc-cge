#
# Representa alguma estatística relacionada a dados de transparência.
#
# Usa STI para ser superclasse das estatísticas específicas, como ServerSalary,
# Contract, ...
#
# Atributos:
#
#  - month:         mês da estatística;
#  - month_start:   mês de inicio das estatísticas em um período
#  - month_end:     mês final das estatísticas em um período
#  - year:          ano da estatística;
#  - type:          coluna usada para herança do STI;
#  - data:          campo serializado com as consolidações das estatísticas;
#

class Stat < ApplicationDataRecord

  # Validations

  ## Presence

  validates :type,
    :month,
    :year,
    presence: true

  validates :month_start,
    presence: true,
    if: -> { self.month_end.present? }

  validates_inclusion_of :month_end,
    in: :month_end_at_range,
    if: -> { self.month_start.present? && self.month_end.present?}


  ## Uniqueness

  validates_uniqueness_of :month,
    scope: [:year, :type],
    if: -> { self.month_end.blank? }

  validates_uniqueness_of :month_end,
    scope: [:year, :type, :month_start],
    unless: -> { self.month_start.blank? }


  # Serializations

  serialize :data, Hash

  #
  # Estatística mais completa e atualizada
  #
  def self.last_stat
    self.sorted.last
  end

  def self.sorted
    order('year asc').order('month_start desc').order('month_end, month asc')
  end


  # privates

  private

  def month_end_at_range
    month_start..12
  end
end
