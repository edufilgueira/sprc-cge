class AddTreatmentToAttendanceEvaluation < ActiveRecord::Migration[5.0]
  def change
    add_column :attendance_evaluations, :treatment, :integer
  end
end