class AddDeletedAtToAttendanceEvaluation < ActiveRecord::Migration[5.0]
  def change
    add_column :attendance_evaluations, :deleted_at, :datetime
    add_index :attendance_evaluations, :deleted_at
  end
end
