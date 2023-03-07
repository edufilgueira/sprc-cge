class  PPA::Revision::Prioritization::RegionTheme < ApplicationRecord
	self.table_name = 'ppa_revision_prioritization_region_themes'

	belongs_to :theme, class_name: 'PPA::Theme'
  belongs_to :region, class_name: 'PPA::Region'
	belongs_to :prioritization

	has_many :regional_strategies, dependent: :destroy

	accepts_nested_attributes_for :regional_strategies

	validates :theme_id, :region_id , presence: true

end
