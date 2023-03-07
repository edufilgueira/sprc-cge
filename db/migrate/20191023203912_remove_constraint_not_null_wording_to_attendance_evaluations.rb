class RemoveConstraintNotNullWordingToAttendanceEvaluations < ActiveRecord::Migration[5.0]
  def change
     change_column_null(:attendance_evaluations, :wording, true)
  end
end
