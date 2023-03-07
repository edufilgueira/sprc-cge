class RemoveAttendanceTypeFromTickets < ActiveRecord::Migration[5.0]
  def change
    remove_column :tickets, :attendance_type, :integer
  end
end
