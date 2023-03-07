class AddInternalStatusToTicket < ActiveRecord::Migration[5.0]
  def change
    add_column :tickets, :internal_status, :integer
  end
end
