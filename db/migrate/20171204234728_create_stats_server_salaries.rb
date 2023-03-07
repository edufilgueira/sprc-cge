class CreateStatsServerSalaries < ActiveRecord::Migration[5.0]
  def change
    create_table :stats_server_salaries do |t|
      t.integer :month
      t.integer :year
      t.text :data

      t.timestamps
    end
    add_index :stats_server_salaries, :month
    add_index :stats_server_salaries, :year
  end
end
