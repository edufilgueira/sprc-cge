class ChangeOtherParticipantionPPAToOtherParticipationPPAOnPPARevisionParticipantProfiles < ActiveRecord::Migration[5.0]
  def change
    rename_column :ppa_revision_participant_profiles, :other_ppa_participantion, :other_ppa_participation
  end
end
