class CreateStatsTickets < ActiveRecord::Migration[5.0]
  def change
    create_table :stats_tickets do |t|
      t.integer :ticket_type
      t.integer :month
      t.integer :year
      t.text :data
      t.integer :status

      t.timestamps
    end
  end
end
