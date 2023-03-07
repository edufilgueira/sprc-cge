class ChangeDisableableSubTopic < ActiveRecord::Migration[5.0]
  def up
    add_column :subtopics, :disabled_at, :datetime
  end

  def down
    remove_column :subtopics, :disabled_at, :datetime
  end
end
