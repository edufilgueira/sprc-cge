class AddUserIdOnPPARevisionParticipantProfiles < ActiveRecord::Migration[5.0]
  def change
    add_reference :ppa_revision_participant_profiles, :user, foreign_key: true
  end
end
