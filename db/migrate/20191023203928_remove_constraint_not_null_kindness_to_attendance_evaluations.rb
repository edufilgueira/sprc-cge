class RemoveConstraintNotNullKindnessToAttendanceEvaluations < ActiveRecord::Migration[5.0]
  def change
     change_column_null(:attendance_evaluations, :kindness, true)
  end
end