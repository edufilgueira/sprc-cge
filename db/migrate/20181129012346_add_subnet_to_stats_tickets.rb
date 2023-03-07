class AddSubnetToStatsTickets < ActiveRecord::Migration[5.0]
  def change
    add_reference :stats_tickets, :subnet, foreign_key: true
  end
end
