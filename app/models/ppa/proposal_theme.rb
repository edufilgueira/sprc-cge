	class PPA::ProposalTheme < ApplicationRecord
	  #include PPA::ProposalTheme::Search
	  include ::Sortable

			# Associations
		  belongs_to :plan, class_name: 'PPA::Plan'
		  belongs_to :region, class_name: 'PPA::Region'
 			
 			# Validations
		  validates :plan, :region, :start_in, :end_in, presence: true		 
		  validates :region, uniqueness: { scope: :plan }
		  validate :valid_date_range
	
		  # Scopes
		  def self.sorted(*)
		    order(:start_in)
		  end		  

			def valid_date_range
		    return unless start_in && end_in
		    errors.add(:end_in, :invalid_range) if end_in <= start_in
		  end

		  # Delegates
		  delegate :name, to: :plan, prefix: true, allow_nil: true
		  delegate :name, to: :region, prefix: true, allow_nil: true
end