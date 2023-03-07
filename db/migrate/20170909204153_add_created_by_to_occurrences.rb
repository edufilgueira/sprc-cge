class AddCreatedByToOccurrences < ActiveRecord::Migration[5.0]
  def change
    add_column :occurrences, :created_by_id, :integer
    add_index :occurrences, :created_by_id
  end
end
