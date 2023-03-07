class AddDescriptionToTicketLog < ActiveRecord::Migration[5.0]
  def change
    add_column :ticket_logs, :description, :text
  end
end
