class AddOtherGenreToPPARevisionParticipantProfile < ActiveRecord::Migration[5.0]
  def change
    add_column :ppa_revision_participant_profiles, :other_genre, :string
  end
end
