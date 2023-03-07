class AddCollumnInvalidateStatusToTicketLog < ActiveRecord::Migration[5.0]
  def change
    add_column :ticket_logs, :invalidate_status, :integer
  end
end
