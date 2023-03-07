class DropStatsServerSalaries < ActiveRecord::Migration[5.0]
  def change
    drop_table :stats_server_salaries
  end
end
