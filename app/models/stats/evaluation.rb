#
# Representa dos dados estatísticos da pesquisa de satisfação
#
class Stats::Evaluation < ApplicationRecord

  # Enumarations
  #
  enum evaluation_type: [:sou, :sic, :call_center, :transparency]


  # Validations

  ## presence

  validates :year,
    :month,
    :evaluation_type,
    presence: true


  ## uniqueness

  validates_uniqueness_of :month,
    scope: [:year, :evaluation_type]


  # Class methods

  ## scopes

  def self.from_year_month_type(year, month, type)
    where(year: year, month: month, evaluation_type: type)
  end

  def self.sorted(type)
    Stats::Evaluation.where(evaluation_type: type).order('year DESC, month DESC')
  end
end
