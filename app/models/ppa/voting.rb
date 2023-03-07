class PPA::Voting < ApplicationRecord
	#include PPA::Voting::Search
	#include ::Sortable

	  belongs_to :plan, class_name: 'PPA::Plan'
	  belongs_to :region, class_name: 'PPA::Region'

	  validates :plan, :region, :start_in, :end_in, presence: true
	  validates :region, uniqueness: { scope: :plan }

		#Delegates
	  delegate :name, to: :plan, prefix: true, allow_nil: true
	  delegate :name, to: :region, prefix: true, allow_nil: true

	  def self.sorted(*)
		  order(:start_in)
		end


end