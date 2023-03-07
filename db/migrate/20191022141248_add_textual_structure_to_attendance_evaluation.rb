class AddTextualStructureToAttendanceEvaluation < ActiveRecord::Migration[5.0]
  def change
    add_column :attendance_evaluations, :textual_structure, :integer
  end
end