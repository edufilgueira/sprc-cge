class AddPublicTicketToTickets < ActiveRecord::Migration[5.0]
  def change
    add_column :tickets, :public_ticket, :boolean, default: false
  end
end
