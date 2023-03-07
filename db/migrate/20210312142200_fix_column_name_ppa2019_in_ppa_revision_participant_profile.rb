class FixColumnNamePpa2019InPPARevisionParticipantProfile < ActiveRecord::Migration[5.0]
  def change
  	rename_column :ppa_revision_participant_profiles, :ppa_2019, :other_ppa_participantion
  end
end
