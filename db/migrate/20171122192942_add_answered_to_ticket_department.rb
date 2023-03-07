class AddAnsweredToTicketDepartment < ActiveRecord::Migration[5.0]
  def change
    add_column :ticket_departments, :answer, :integer, default: 0
  end
end
