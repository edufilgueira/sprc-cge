class AddQualityToAttendanceEvaluation < ActiveRecord::Migration[5.0]
  def change
    add_column :attendance_evaluations, :quality, :integer
  end
end