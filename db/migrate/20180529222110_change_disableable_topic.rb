class ChangeDisableableTopic < ActiveRecord::Migration[5.0]
  def up
    add_column :topics, :disabled_at, :datetime
  end

  def down
    remove_column :topics, :disabled_at, :datetime
  end
end
