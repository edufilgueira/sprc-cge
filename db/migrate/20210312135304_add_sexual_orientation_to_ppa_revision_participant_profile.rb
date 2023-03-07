class AddSexualOrientationToPPARevisionParticipantProfile < ActiveRecord::Migration[5.0]
  def change
    add_column :ppa_revision_participant_profiles, :sexual_orientation, :integer
  end
end
