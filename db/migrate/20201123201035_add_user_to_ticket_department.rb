class AddUserToTicketDepartment < ActiveRecord::Migration[5.0]
  def change
    add_reference :ticket_departments, :user, foreign_key: true
  end
end
