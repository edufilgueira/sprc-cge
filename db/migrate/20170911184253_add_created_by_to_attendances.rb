class AddCreatedByToAttendances < ActiveRecord::Migration[5.0]
  def change
    add_column :attendances, :created_by_id, :integer
    add_index :attendances, :created_by_id
    add_column :attendances, :updated_by_id, :integer
    add_index :attendances, :updated_by_id
  end
end
