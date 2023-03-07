class CreatePPARevisionParticipantProfile < ActiveRecord::Migration[5.0]
  def change
    create_table :ppa_revision_participant_profiles do |t|

    	t.integer :age
    	t.integer :genre
    	t.integer :breed
    	t.integer :ethnic_group
    	t.integer :educational_level1
    	t.integer :family_income
    	t.integer :representative
    	t.string  :representative_description
    	t.string :collegiate
    	t.boolean :ppa_2019
        t.timestamps
    end
  end
end