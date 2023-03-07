class PPA::Revision::Prioritization < ApplicationRecord
  self.table_name = 'ppa_revision_prioritizations'

  belongs_to :user
  belongs_to :plan, class_name: 'PPA::Plan'
  has_many :region_themes, dependent: :destroy
  has_many :regions, through: :region_themes

  # has_many :problem_situations, through: :region_themes
  has_many :regional_strategies, through: :region_themes

  accepts_nested_attributes_for :region_themes

  validates_presence_of :plan_id
  validates_presence_of :user_id
  validates_uniqueness_of :user_id, scope: :plan_id
end