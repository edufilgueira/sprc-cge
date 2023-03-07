class AddOtherSexualOrientationToPPARevisionParticipantProfile < ActiveRecord::Migration[5.0]
  def change
    add_column :ppa_revision_participant_profiles, :other_sexual_orientation, :string
  end
end
