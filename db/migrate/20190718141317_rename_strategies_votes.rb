class RenameStrategiesVotes < ActiveRecord::Migration[5.0]
  def change
    rename_table :ppa_strategies_votes, :ppa_strategies_vote_items
  end
end
