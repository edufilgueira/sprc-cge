class AddTicketDepartmentToExtensions < ActiveRecord::Migration[5.0]
  def change
    add_reference :extensions, :ticket_department, foreign_key: true
  end
end
