class AddMonthPeriodToStatsTickets < ActiveRecord::Migration[5.0]
  def change
    rename_column :stats_tickets, :month, :month_start
    add_column :stats_tickets, :month_end, :integer
  end
end
