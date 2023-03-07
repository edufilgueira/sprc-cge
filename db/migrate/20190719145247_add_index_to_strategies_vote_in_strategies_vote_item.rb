class AddIndexToStrategiesVoteInStrategiesVoteItem < ActiveRecord::Migration[5.0]
  def change
    add_index :ppa_strategies_vote_items, :strategies_vote_id
  end
end
