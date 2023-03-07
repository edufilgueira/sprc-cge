class AddCallCenterResponsibleToTickets < ActiveRecord::Migration[5.0]
  def change
    add_column :tickets, :call_center_responsible_id, :integer
    add_index :tickets, :call_center_responsible_id
  end
end
