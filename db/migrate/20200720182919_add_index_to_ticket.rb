class AddIndexToTicket < ActiveRecord::Migration[5.0]
  def change
  	add_index :tickets, [:ticket_type, :sou_type, :internal_status]
  end
end
