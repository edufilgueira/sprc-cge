class PPA::Revision::Review::RegionTheme < ApplicationRecord

  # MAX_REGIONS_PER_STRATEGY = 2

  has_many :problem_situations, dependent: :destroy
  has_many :regional_strategies, dependent: :destroy
  has_many :new_regional_strategies, dependent: :destroy
  has_many :new_problem_situations, dependent: :destroy

  belongs_to :theme, class_name: 'PPA::Theme'
  belongs_to :region, class_name: 'PPA::Region'
  belongs_to :problem_situation_strategy

  accepts_nested_attributes_for :problem_situations
  accepts_nested_attributes_for :regional_strategies
  accepts_nested_attributes_for :new_regional_strategies
  accepts_nested_attributes_for :new_problem_situations

  validates :theme_id, :region_id , presence: true

  # validate :validate_region_limit


  # private

  # def validate_region_limit
  #   if problem_situation_strategy.regions.distinct.count >= MAX_REGIONS_PER_STRATEGY
  #     errors.add(:region_id, "Limite de #{MAX_REGIONS_PER_STRATEGY} regiões diferentes cadastradas foi atingido")
  #   end
  # end
end