class  PPA::Revision::Prioritization::RegionalStrategy < ApplicationRecord
	self.table_name = 'ppa_revision_prioritization_regional_strategies'

	belongs_to :region_theme
	belongs_to :strategy, class_name: 'PPA::Strategy'

end
