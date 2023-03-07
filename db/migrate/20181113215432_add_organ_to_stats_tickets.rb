class AddOrganToStatsTickets < ActiveRecord::Migration[5.0]
  def change
    add_reference :stats_tickets, :organ, foreign_key: true
  end
end
