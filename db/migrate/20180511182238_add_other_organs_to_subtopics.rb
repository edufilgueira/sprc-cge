class AddOtherOrgansToSubtopics < ActiveRecord::Migration[5.0]
  def change
    add_column :subtopics, :other_organs, :boolean, default: false
  end
end
