class RenameTicketSubNetColumns < ActiveRecord::Migration[5.0]
  def change
    rename_column :tickets, :department_id, :subnet_id
    rename_column :tickets, :unknown_department, :unknown_subnet
  end
end
