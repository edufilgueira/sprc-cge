class AddClassificationToAttendanceEvaluation < ActiveRecord::Migration[5.0]
  def change
    add_column :attendance_evaluations, :classification, :integer
  end
end