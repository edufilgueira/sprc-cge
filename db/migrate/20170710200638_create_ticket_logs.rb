class CreateTicketLogs < ActiveRecord::Migration[5.0]
  def change
    create_table :ticket_logs do |t|
      t.references :ticket, foreign_key: true
      t.references :responsible, polymorphic: true, index: true
      t.integer :action
      t.references :resource, polymorphic: true, index: true

      t.timestamps
    end
  end
end
