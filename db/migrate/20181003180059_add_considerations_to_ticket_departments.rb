class AddConsiderationsToTicketDepartments < ActiveRecord::Migration[5.0]
  def change
    add_column :ticket_departments, :considerations, :string
  end
end
