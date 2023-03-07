class ChangeEducationalLevel1ToEducationalLevelOnPPAProfiles < ActiveRecord::Migration[5.0]
  def change
    rename_column :ppa_revision_participant_profiles, :educational_level1, :educational_level
  end
end
