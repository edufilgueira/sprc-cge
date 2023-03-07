class AddAttendanceTypeToTickets < ActiveRecord::Migration[5.0]
  def change
    add_column :tickets, :attendance_type, :integer
  end
end
