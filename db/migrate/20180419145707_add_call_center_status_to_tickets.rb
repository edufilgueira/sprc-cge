class AddCallCenterStatusToTickets < ActiveRecord::Migration[5.0]
  def change
    add_column :tickets, :call_center_status, :integer, null: true
  end
end
