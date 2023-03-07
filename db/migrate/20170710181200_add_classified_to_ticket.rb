class AddClassifiedToTicket < ActiveRecord::Migration[5.0]
  def change
    add_column :tickets, :classified, :boolean, default: false
  end
end
