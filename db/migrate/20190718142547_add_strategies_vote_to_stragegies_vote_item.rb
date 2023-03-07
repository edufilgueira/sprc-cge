class AddStrategiesVoteToStragegiesVoteItem < ActiveRecord::Migration[5.0]
  def change
    add_column :ppa_strategies_vote_items, :strategies_vote_id, :integer
    add_foreign_key :ppa_strategies_vote_items, :ppa_strategies_votes, column: :strategies_vote_id
  end
end
