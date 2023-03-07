class AddDataToTicketLogs < ActiveRecord::Migration[5.0]
  def change
    add_column :ticket_logs, :data, :text
  end
end
