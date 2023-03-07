class AddDeficiencyToPPARevisionParticipantProfile < ActiveRecord::Migration[5.0]
  def change
    add_column :ppa_revision_participant_profiles, :deficiency, :integer
    add_column :ppa_revision_participant_profiles, :other_deficiency, :string
  end
end
