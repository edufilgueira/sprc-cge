class OrganAssociation < ApplicationRecord
	include ::Sortable
	include ::Disableable
	include ::Upcaseable


	# Setup

	acts_as_paranoid

	# Associations

	belongs_to :organ
	belongs_to :organ_association, foreign_key: "organ_association_id", class_name: "Organ"

	#  Validations

	## Presence

	validates :organ_id, :organ_association_id,	presence: true

	#validates :organ_id, :organ_association_id, uniqueness: true

	# Scopes

	def self.sorted
		order(:organ_association_id)
	end

	# Instace methods

	## Helpers

	def title
		organ.name
	end
end
