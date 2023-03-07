class PPA::Revision::Review::ProblemSituationStrategy < ApplicationRecord
  self.table_name = 'ppa_revision_review_problem_situation_strategies'

  belongs_to :user
  belongs_to :plan, class_name: 'PPA::Plan'
  has_many :region_themes, dependent: :destroy
  has_many :regions, through: :region_themes

  has_many :problem_situations, through: :region_themes
  has_many :regional_strategies, through: :region_themes
  has_many :new_regional_strategies, through: :region_themes
  has_many :new_problem_situations, through: :region_themes

  accepts_nested_attributes_for :region_themes

  validates :plan_id, :user_id, presence: true
  validates :plan_id,  uniqueness: { scope: :user_id }

end