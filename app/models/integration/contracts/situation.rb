class Integration::Contracts::Situation < ApplicationDataRecord
	include ::Sortable

	def self.default_sort_column
    'integration_contracts_situations.description'
  end


  ## Instance methods

  ### Helpers

  def title
    description
  end
end

