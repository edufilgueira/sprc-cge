class RemoveFirldsFromStrategiesVote < ActiveRecord::Migration[5.0]
  def change
    remove_column :ppa_strategies_votes, :user_id
    remove_column :ppa_strategies_votes, :region_id
  end
end
