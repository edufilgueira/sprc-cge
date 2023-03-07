class PPA::Revision::ParticipantProfile < ApplicationRecord
	self.table_name = 'ppa_revision_participant_profiles'

	belongs_to :user

	enum age: [:smaller_18, :between_18_29, :between_30_45, :between_46_60, :above_60]

	enum genre: [:men_cis, :woman_cis, :men_trans, :woman_trans, :other_genre]

	enum sexual_orientation: [:heterosexual, :bisexual, :lesbian, :gay, :other_sexual_orientation]

	enum deficiency: [
		:physical_disability, :deafness, :low_vision, :blindness, :deafblindness, :autism_spectrum_disorder,
		:giftedness, :rare_syndromes, :intellectual_disability, :multiple_disability, :other_deficiency
	]

	enum breed: [:white, :black, :parda, :yellow, :indigene]

	enum ethnic_group: [
		:indigenous, :quilombolas, :gypsies, :people_of_religious_communities_of_african_origin, :other_ethnic_group
	]

	enum educational_level: [
		:incomplete_elementary_school,
		:complete_elementary_school,
		:incomplete_high_school,
		:complete_high_school,
		:incomplete_higher_education,
		:complete_higher_education,
		:specialization,
		:masters_degree,
		:doctorate_degree,
		:post_doctoral
	]

	enum family_income: [
		:less_than_1100, :between_1100_2200, :between_2201_4400, :between_4401_6600, :above_6600
	]

	enum representative: [
		:civil_society, :government_or_government_entities, :productive_or_business_or_development_segment
	]

	validates_presence_of :user_id
	validates_uniqueness_of :user_id

	# Garantindo a integridade dos dados já que os campos não podem ser obrigatórios
	before_save :set_genre_to_other, if: -> { other_genre.present? }
	before_save :set_sexual_orientation_to_other, if: -> { other_sexual_orientation.present? }
	before_save :set_deficiency_to_other, if: -> { other_deficiency.present? }

	private

	def set_genre_to_other
		self.genre = :other_genre
	end

	def set_sexual_orientation_to_other
		self.sexual_orientation = :other_sexual_orientation
	end

	def set_deficiency_to_other
		self.deficiency = :other_deficiency
	end
end
