class AddIndex2ToTicket < ActiveRecord::Migration[5.0]
  def change
  	add_index :tickets, [:ticket_type, :deadline, :internal_status, :extended], name: 'index_ticket_type_deadline_internal_status_extended'
  	
  end
end
