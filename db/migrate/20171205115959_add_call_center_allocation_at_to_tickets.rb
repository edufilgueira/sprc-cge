class AddCallCenterAllocationAtToTickets < ActiveRecord::Migration[5.0]
  def change
    add_column :tickets, :call_center_allocation_at, :datetime
  end
end
