class PPA::Revision::Schedule < ApplicationRecord
	self.table_name = 'ppa_revision_schedules'
	include ::Sortable
	# include PPA::Schedule::Search

	# Enums
	enum stage: {
		review_regional_guidelines: 0,
		proposal_consolidation: 1,
		prioritization_regional_strategies: 2,
		disclosure_final_result: 3,
		process_evaluation: 4
	}

	belongs_to :plan, class_name: 'PPA::Plan'

	validates :plan, :stage, :start_in, :end_in, presence: true
	validates :stage, uniqueness: { scope: :plan }

	#Delegates
	delegate :name, to: :plan, prefix: true, allow_nil: true


	def self.sorted(*)
			order(:start_in)
	end

	def stage_str
		return '' unless stage.present?

    PPA::Revision::Schedule.human_attribute_name("#{stage}")
	end
end
