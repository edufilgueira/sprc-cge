class AddTimestampToStrategiesVote < ActiveRecord::Migration[5.0]
  def change
    add_column :ppa_strategies_votes, :created_at, :datetime, null: false
    add_column :ppa_strategies_votes, :updated_at, :datetime, null: false
    add_column :ppa_strategies_vote_items, :created_at, :datetime, null: false
    add_column :ppa_strategies_vote_items, :updated_at, :datetime, null: false
  end
end
